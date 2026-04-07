#!/usr/bin/env python3
"""Collect normalized jj stack context for labeling and split planning."""

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
    'description.first_line() ++ "\\n"'
)
SUSPICIOUS_PATTERNS = (
    "__pycache__/",
    ".pyc",
    ".DS_Store",
    ".cache/",
    "node_modules/",
    ".direnv/",
    ".env",
    "secrets",
    "credential",
)
SNAPSHOT_MODE = "live"


@dataclass(slots=True)
class RevisionInfo:
    change_id: str
    commit_id: str
    description: str
    description_empty: bool


@dataclass(slots=True)
class ChangedFile:
    status: str
    path: str
    category: str


@dataclass(slots=True)
class DiffStats:
    files_changed: int
    insertions: int
    deletions: int

    @property
    def total_changed_lines(self) -> int:
        return self.insertions + self.deletions


def is_placeholder_description(description: str) -> bool:
    normalized = description.strip()
    return normalized == "" or normalized.lower().startswith("wip:")


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
        parts = line.split("\t", maxsplit=2)
        if len(parts) != 3:
            continue
        change_id, commit_id, description = parts
        revisions.append(
            RevisionInfo(
                change_id=change_id.strip(),
                commit_id=commit_id.strip(),
                description=description.strip(),
                description_empty=description.strip() == "",
            )
        )
    return revisions


def get_revision(revision: str) -> RevisionInfo | None:
    revisions = parse_revision_block(revision)
    return revisions[0] if revisions else None


def get_parent_revisions(revision: str) -> list[RevisionInfo]:
    return parse_revision_block(f"parents({revision})")


def resolve_default_scope() -> list[RevisionInfo]:
    collected: dict[str, RevisionInfo] = {}
    queue = ["@"]

    while queue:
        rev = queue.pop(0)
        current = get_revision(rev)
        if current is None or current.commit_id in collected:
            continue
        collected[current.commit_id] = current
        for parent in get_parent_revisions(rev):
            if is_placeholder_description(parent.description) and parent.commit_id not in collected:
                queue.append(parent.change_id)

    if not collected:
        return []

    union_revset = "|".join(item.commit_id for item in collected.values())
    ordered = parse_revision_block(union_revset)
    ordered.reverse()
    return ordered


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


def parse_diff_stats(revision: str) -> DiffStats:
    output = run_jj(["diff", "-r", revision, "--stat"])
    files_changed = 0
    insertions = 0
    deletions = 0

    summary_re = re.compile(
        r"(?P<files>\d+)\s+files? changed(?:,\s+(?P<ins>\d+)\s+insertions?\(\+\))?(?:,\s+(?P<del>\d+)\s+deletions?\(-\))?"
    )
    for line in output.splitlines():
        match = summary_re.search(line)
        if not match:
            continue
        files_changed = int(match.group("files"))
        insertions = int(match.group("ins") or 0)
        deletions = int(match.group("del") or 0)
        break

    return DiffStats(
        files_changed=files_changed,
        insertions=insertions,
        deletions=deletions,
    )


def detect_scope(files: list[str]) -> str | None:
    scopes: list[str] = []
    for file in files:
        parts = [part for part in Path(file).parts if part not in {"."}]
        if not parts:
            continue
        if len(parts) >= 2 and parts[0] in {"packages", "drivers", "modules"}:
            scopes.append(parts[1])
        else:
            scopes.append(parts[0])

    if not scopes:
        return None

    top, count = Counter(scopes).most_common(1)[0]
    if count < max(2, len(scopes) // 2):
        return None
    return top


def has_any(text: str, needles: tuple[str, ...]) -> bool:
    return any(needle in text for needle in needles)


def classify_type(subject: str, files: list[str]) -> tuple[str, str, str]:
    s = subject.lower()
    paths = " ".join(files).lower()

    if has_any(s, ("fix", "bug", "issue", "crash", "error", "incorrect", "wrong", "hotfix", "revert")):
        return "fix", "high", "subject indicates corrective change"
    if has_any(s, ("add", "support", "implement", "introduce", "create", "enable", "allow", "new ")):
        return "feat", "high", "subject indicates new capability"
    if has_any(s + " " + paths, ("docs", "readme", "changelog", ".md")):
        return "docs", "high", "docs keywords or markdown paths detected"
    if has_any(s + " " + paths, ("test", "pytest", "unittest", "fixture", "spec")):
        return "test", "high", "test-related keywords detected"
    if has_any(s, ("refactor", "cleanup", "restructure", "rename", "simplify", "extract")):
        return "refactor", "high", "subject indicates structural cleanup"
    if has_any(s, ("perf", "optimi", "faster", "latency", "throughput", "speed")):
        return "perf", "high", "subject indicates performance work"
    if has_any(
        s + " " + paths,
        ("pyproject.toml", "uv.lock", "setup.py", "requirements", "dependency", "nuitka", "justfile", "flake.nix", "flake.lock"),
    ):
        return "build", "medium", "build or dependency files changed"
    if has_any(s + " " + paths, ("github/workflows", "pipeline", "ci", "actions", "buildkite", "azure-pipelines")):
        return "ci", "medium", "CI workflow signals detected"
    if has_any(s, ("format", "lint", "whitespace", "style")) or has_any(paths, (".ruff",)):
        return "style", "medium", "formatting or lint indicators detected"
    if files:
        return "chore", "low", "no strong semantic signal; defaulting to chore"
    return "chore", "low", "empty or metadata-only change"


def detect_breaking(subject: str) -> bool:
    lowered = subject.lower()
    return bool(
        re.search(r"\bbreak(ing)?\b", lowered)
        or has_any(lowered, ("drop support", "remove api", "incompatible", "migration required"))
    )


def summarize_subject(subject: str, semantic_type: str) -> str:
    summary = subject.strip()
    conventional_prefix = re.match(r"^[a-z]+(\([a-z0-9_-]+\))?(!)?:\s*", summary, flags=re.IGNORECASE)
    if conventional_prefix:
        summary = summary[conventional_prefix.end() :].strip()
    summary = re.sub(r"\s+", " ", summary)
    if summary:
        return summary[0].lower() + summary[1:]
    return f"update related to {semantic_type}"


def build_label(semantic_type: str, scope: str | None, breaking: bool, summary: str) -> str:
    scope_fragment = f"({scope})" if scope else ""
    bang = "!" if breaking else ""
    return f"{semantic_type}{scope_fragment}{bang}: {summary}"


def detect_semantic_buckets(subject: str, changed_files: list[ChangedFile], semantic_type: str) -> list[str]:
    buckets: list[str] = []
    categories = {item.category for item in changed_files}
    lowered = subject.lower()

    if "source" in categories:
        if semantic_type in {"feat", "fix", "perf"}:
            buckets.append("behavior change")
        elif semantic_type == "refactor" or has_any(lowered, ("rename", "extract", "cleanup", "restructure", "simplify")):
            buckets.append("prerequisite refactor")
        elif semantic_type == "style":
            buckets.append("polish")
        else:
            buckets.append("behavior change")
    if "tests" in categories:
        buckets.append("tests")
    if "docs" in categories:
        buckets.append("docs")
    if "tooling" in categories or "ci" in categories or semantic_type in {"build", "ci"}:
        buckets.append("tooling")
    if semantic_type == "style" and "polish" not in buckets:
        buckets.append("polish")

    seen: set[str] = set()
    ordered: list[str] = []
    for bucket in buckets:
        if bucket not in seen:
            seen.add(bucket)
            ordered.append(bucket)
    return ordered


def find_suspicious_files(changed_files: list[ChangedFile]) -> list[str]:
    suspicious: list[str] = []
    for item in changed_files:
        lowered = item.path.lower()
        if any(pattern.lower() in lowered for pattern in SUSPICIOUS_PATTERNS):
            suspicious.append(item.path)
    return suspicious


def collect_revision_payload(revision: RevisionInfo) -> dict[str, object]:
    changed_files = parse_changed_files(revision.change_id)
    diff_stats = parse_diff_stats(revision.change_id)
    file_paths = [item.path for item in changed_files]
    semantic_type, confidence, rationale = classify_type(revision.description, file_paths)
    scope = detect_scope(file_paths)
    breaking = detect_breaking(revision.description)
    summary = summarize_subject(revision.description, semantic_type)
    label = build_label(semantic_type, scope, breaking, summary)
    buckets = detect_semantic_buckets(revision.description, changed_files, semantic_type)
    suspicious_files = find_suspicious_files(changed_files)
    should_split = diff_stats.total_changed_lines > 1000 and len(buckets) > 1

    return {
        "revision": asdict(revision),
        "changed_files": [asdict(item) for item in changed_files],
        "diff_stats": asdict(diff_stats) | {"total_changed_lines": diff_stats.total_changed_lines},
        "suggested_label": label,
        "semantic_type": semantic_type,
        "scope": scope,
        "breaking": breaking,
        "confidence": confidence,
        "rationale": rationale,
        "semantic_buckets": buckets,
        "should_split": should_split,
        "split_reason": (
            "revision exceeds 1000 changed lines and spans multiple semantic buckets"
            if should_split
            else "keep intact unless manual review finds clearer split boundaries"
        ),
        "suspicious_files": suspicious_files,
    }


def render_text(scope_mode: str, revisions: list[dict[str, object]]) -> str:
    lines = [
        f"scope_mode: {scope_mode}",
        f"snapshot_mode: {SNAPSHOT_MODE}",
        "",
    ]
    for item in revisions:
        revision = item["revision"]
        diff_stats = item["diff_stats"]
        lines.append(f"[revision {revision['change_id']}]")
        lines.append(f"commit_id: {revision['commit_id']}")
        lines.append(f"description: {revision['description']}")
        lines.append(f"description_empty: {str(revision['description_empty']).lower()}")
        lines.append(f"suggested_label: {item['suggested_label']}")
        lines.append(f"confidence: {item['confidence']}")
        lines.append(f"rationale: {item['rationale']}")
        lines.append(f"semantic_buckets: {json.dumps(item['semantic_buckets'])}")
        lines.append(f"should_split: {json.dumps(item['should_split'])}")
        lines.append(f"split_reason: {item['split_reason']}")
        lines.append(f"diff_stats: {json.dumps(diff_stats, sort_keys=True)}")
        lines.append(f"suspicious_files: {json.dumps(item['suspicious_files'])}")
        lines.append("[changed_files]")
        changed_files = item["changed_files"]
        if changed_files:
            for changed in changed_files:
                lines.append(f"{changed['status']}\t{changed['category']}\t{changed['path']}")
        else:
            lines.append("(none)")
        lines.append("")
    return "\n".join(lines).rstrip() + "\n"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Collect normalized jj stack context for labeling and split planning.",
    )
    parser.add_argument(
        "--revision",
        help="Analyze only this revision.",
    )
    parser.add_argument(
        "--revset",
        help="Analyze this revset instead of the default scope.",
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
        if args.revset:
            scope_mode = f"revset:{args.revset}"
            revisions = parse_revision_block(args.revset)
            revisions.reverse()
        elif args.revision:
            scope_mode = f"revision:{args.revision}"
            revisions = parse_revision_block(args.revision)
        else:
            scope_mode = "default:@+empty-or-wip-ancestors"
            revisions = resolve_default_scope()

        payload = {
            "scope_mode": scope_mode,
            "snapshot_mode": SNAPSHOT_MODE,
            "revisions": [collect_revision_payload(revision) for revision in revisions],
        }
    except RuntimeError as err:
        print(f"Error: {err}", file=sys.stderr)
        return 1

    if args.json:
        print(json.dumps(payload, indent=2))
    else:
        print(render_text(scope_mode, payload["revisions"]), end="")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
