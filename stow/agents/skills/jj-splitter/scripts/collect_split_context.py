#!/usr/bin/env python3
"""Collect normalized jj revision context for split planning."""

from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from collections import Counter
from dataclasses import asdict, dataclass
from pathlib import Path


REVISION_TEMPLATE = (
    'change_id.short(8) ++ "\\t" ++ commit_id.short(12) ++ "\\t" ++ '
    'description.first_line() ++ "\\t" ++ empty ++ "\\n"'
)
SNAPSHOT_MODE = "live"


@dataclass(slots=True)
class RevisionInfo:
    change_id: str
    commit_id: str
    description: str
    empty: bool


@dataclass(slots=True)
class ChangedFile:
    status: str
    path: str
    category: str


def run_jj(args: list[str]) -> str:
    global SNAPSHOT_MODE

    proc = subprocess.run(
        ["jj", "--quiet", *args],
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace",
        check=False,
    )
    if proc.returncode == 0:
        return proc.stdout

    stderr = proc.stderr.strip() or "jj command failed"
    if "Failed to snapshot the working copy" in stderr:
        fallback = subprocess.run(
            ["jj", "--ignore-working-copy", "--quiet", *args],
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
            check=False,
        )
        if fallback.returncode == 0:
            SNAPSHOT_MODE = "stale-ignore-working-copy"
            return fallback.stdout

    raise RuntimeError(stderr)


def parse_revision_block(revset: str) -> list[RevisionInfo]:
    output = run_jj(["log", "--no-graph", "-r", revset, "-T", REVISION_TEMPLATE])
    revisions: list[RevisionInfo] = []
    for line in output.splitlines():
        if not line.strip():
            continue
        parts = line.split("\t", maxsplit=3)
        if len(parts) != 4:
            continue
        change_id, commit_id, description, empty = parts
        revisions.append(
            RevisionInfo(
                change_id=change_id.strip(),
                commit_id=commit_id.strip(),
                description=description.strip(),
                empty=empty.strip().lower() == "true",
            )
        )
    return revisions


def categorize_path(path: str) -> str:
    lowered = path.lower()
    path_obj = Path(path)
    parts = {part.lower() for part in path_obj.parts}

    if lowered.endswith((".md", ".rst", ".adoc")) or "docs" in parts:
        return "docs"
    if any(part in {"test", "tests", "__tests__", "spec", "specs"} for part in parts):
        return "tests"
    if path_obj.name in {
        "flake.nix",
        "flake.lock",
        "package.json",
        "package-lock.json",
        "pnpm-lock.yaml",
        "cargo.toml",
        "cargo.lock",
        "pyproject.toml",
        "uv.lock",
        "justfile",
        ".tool-versions",
    }:
        return "tooling"
    if ".github" in parts or "workflows" in parts:
        return "ci"
    return "source"


def parse_changed_files(revision: str) -> list[ChangedFile]:
    output = run_jj(["diff", "-r", revision, "--summary"])
    changed_files: list[ChangedFile] = []

    for line in output.splitlines():
        stripped = line.strip()
        if not stripped:
            continue
        match = re.match(r"^(A|M|D|R|C)\s+(.*)$", stripped)
        if not match:
            continue
        path = match.group(2).strip()
        changed_files.append(
            ChangedFile(
                status=match.group(1),
                path=path,
                category=categorize_path(path),
            )
        )

    return changed_files


def derive_hints(changed_files: list[ChangedFile]) -> dict[str, object]:
    category_counts = Counter(item.category for item in changed_files)
    top_level_counts = Counter(Path(item.path).parts[0] if Path(item.path).parts else "." for item in changed_files)
    status_counts = Counter(item.status for item in changed_files)
    category_priority = {
        "tooling": 1,
        "ci": 2,
        "source": 3,
        "tests": 4,
        "docs": 5,
    }

    categories = [name for name, count in category_counts.most_common() if count > 0]
    dominant_category = categories[0] if categories else "none"

    if not changed_files:
        split_strategy = "nothing-to-split"
        split_recommendation = "no-meaningful-diff"
    elif len(changed_files) == 1:
        split_strategy = "inspect-hunks"
        split_recommendation = "keep-intact-unless-hunks-show-mixed-intent"
    elif len(categories) > 1:
        split_strategy = "start-with-file-based-split"
        split_recommendation = "separate-distinct-file-groups-first"
    else:
        split_strategy = "inspect-patch-for-intent-boundaries"
        split_recommendation = "split-only-if-patch-shows-clear-boundaries"

    return {
        "category_counts": dict(category_counts),
        "status_counts": dict(status_counts),
        "top_level_counts": dict(top_level_counts),
        "dominant_category": dominant_category,
        "mixed_categories": len(categories) > 1,
        "review_order": sorted(categories, key=lambda name: category_priority.get(name, 99)),
        "likely_split_strategy": split_strategy,
        "split_recommendation": split_recommendation,
    }


def render_text(
    revision: str,
    snapshot_mode: str,
    target: RevisionInfo | None,
    parents: list[RevisionInfo],
    children: list[RevisionInfo],
    changed_files: list[ChangedFile],
    hints: dict[str, object],
    patch: str,
) -> str:
    lines: list[str] = []
    lines.append(f"revision: {revision}")
    lines.append(f"snapshot_mode: {snapshot_mode}")
    lines.append("")
    lines.append("[target]")
    if target is None:
        lines.append("missing: true")
    else:
        lines.append(f"change_id: {target.change_id}")
        lines.append(f"commit_id: {target.commit_id}")
        lines.append(f"description: {target.description}")
        lines.append(f"empty: {str(target.empty).lower()}")
    lines.append("")
    lines.append("[parents]")
    if parents:
        for item in parents:
            lines.append(f"{item.change_id}\t{item.commit_id}\t{item.description}")
    else:
        lines.append("(none)")
    lines.append("")
    lines.append("[children]")
    if children:
        for item in children:
            lines.append(f"{item.change_id}\t{item.commit_id}\t{item.description}")
    else:
        lines.append("(none)")
    lines.append("")
    lines.append("[changed_files]")
    if changed_files:
        for item in changed_files:
            lines.append(f"{item.status}\t{item.category}\t{item.path}")
    else:
        lines.append("(none)")
    lines.append("")
    lines.append("[hints]")
    for key, value in hints.items():
        lines.append(f"{key}: {json.dumps(value, sort_keys=True)}")
    lines.append("")
    lines.append("[patch]")
    lines.append(patch.rstrip())
    return "\n".join(lines).rstrip() + "\n"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Collect normalized jj revision context for split planning.",
    )
    parser.add_argument(
        "--revision",
        default="@",
        help="Revision to inspect (default: @).",
    )
    parser.add_argument(
        "--json",
        action="store_true",
        help="Emit JSON instead of plain text.",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()

    try:
        target_block = parse_revision_block(args.revision)
        target = target_block[0] if target_block else None
        parents = parse_revision_block(f"parents({args.revision})")
        children = parse_revision_block(f"children({args.revision})")
        changed_files = parse_changed_files(args.revision)
        hints = derive_hints(changed_files)
        patch = run_jj(["diff", "-r", args.revision, "--git"])
    except RuntimeError as err:
        print(f"Error: {err}", file=sys.stderr)
        return 1

    payload = {
        "revision": args.revision,
        "snapshot_mode": SNAPSHOT_MODE,
        "target": asdict(target) if target else None,
        "parents": [asdict(item) for item in parents],
        "children": [asdict(item) for item in children],
        "changed_files": [asdict(item) for item in changed_files],
        "hints": hints,
        "patch": patch,
    }

    if args.json:
        print(json.dumps(payload, indent=2))
    else:
        print(
            render_text(
                args.revision,
                SNAPSHOT_MODE,
                target,
                parents,
                children,
                changed_files,
                hints,
                patch,
            ),
            end="",
        )

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
