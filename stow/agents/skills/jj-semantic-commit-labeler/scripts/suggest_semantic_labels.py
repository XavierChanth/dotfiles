#!/usr/bin/env python3
"""Suggest Conventional Commit labels for commits in a jj revset."""

from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from collections import Counter
from dataclasses import asdict, dataclass
from pathlib import Path


@dataclass(slots=True)
class CommitSuggestion:
    change_id: str
    commit_id: str
    original: str
    suggested: str
    semantic_type: str
    scope: str | None
    breaking: bool
    confidence: str
    rationale: str
    files: list[str]


def run_jj(args: list[str]) -> str:
    proc = subprocess.run(
        ["jj", "--ignore-working-copy", *args],
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace",
        check=False,
    )
    if proc.returncode != 0:
        raise RuntimeError(proc.stderr.strip() or "jj command failed")
    return proc.stdout


def parse_log(revset: str, limit: int | None) -> list[tuple[str, str, str]]:
    template = r'change_id.short(8) ++ "\t" ++ commit_id.short(12) ++ "\t" ++ description.first_line() ++ "\n"'
    cmd = ["log", "--no-graph", "-r", revset, "-T", template]
    if limit is not None:
        cmd.extend(["-n", str(limit)])
    output = run_jj(cmd)

    commits: list[tuple[str, str, str]] = []
    for line in output.splitlines():
        if not line.strip():
            continue
        parts = line.split("\t", maxsplit=2)
        if len(parts) != 3:
            continue
        change_id, commit_id, first_line = parts
        commits.append((change_id.strip(), commit_id.strip(), first_line.strip()))
    return commits


def parse_changed_files(rev: str) -> list[str]:
    output = run_jj(["show", "-r", rev, "--summary"])
    files: list[str] = []
    for line in output.splitlines():
        stripped = line.strip()
        if not stripped:
            continue
        match = re.match(r"^(A|M|D|R|C)\s+(.*)$", stripped)
        if match:
            files.append(match.group(2).strip())
            continue
        match = re.match(r"^(Added|Modified|Removed|Copied|Renamed)\s+(.*)$", stripped, flags=re.IGNORECASE)
        if match:
            files.append(match.group(2).strip())
    return files


def detect_scope(files: list[str]) -> str | None:
    if not files:
        return None

    scopes: list[str] = []
    for file in files:
        parts = [p for p in Path(file).parts if p not in {"."}]
        if not parts:
            continue
        if len(parts) >= 2 and parts[0] in {"packages", "drivers"}:
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
    return any(n in text for n in needles)


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

    if has_any(s, ("refactor", "cleanup", "restructure", "rename", "simplify")):
        return "refactor", "high", "subject indicates structural cleanup"

    if has_any(s, ("perf", "optimi", "faster", "latency", "throughput", "speed")):
        return "perf", "high", "subject indicates performance work"

    if has_any(s + " " + paths, ("pyproject.toml", "uv.lock", "setup.py", "requirements", "dependency", "nuitka", "justfile")):
        return "build", "medium", "build/dependency files changed"

    if has_any(s + " " + paths, ("github/workflows", "pipeline", "ci", "actions", "buildkite", "azure-pipelines")):
        return "ci", "medium", "CI workflow signals detected"

    if has_any(s, ("format", "lint", "whitespace", "style")) or has_any(paths, (".ruff",)):
        return "style", "medium", "formatting/lint indicators detected"

    if files:
        return "chore", "low", "no strong semantic signal; defaulting to chore"

    return "chore", "low", "empty or metadata-only change"


def detect_breaking(subject: str) -> bool:
    s = subject.lower()
    return bool(
        re.search(r"\bbreak(ing)?\b", s)
        or has_any(s, ("drop support", "remove api", "incompatible", "migration required"))
    )


def summarize_subject(subject: str, semantic_type: str) -> str:
    s = subject.strip()
    conventional_prefix = re.match(r"^[a-z]+(\([a-z0-9_-]+\))?(!)?:\s*", s, flags=re.IGNORECASE)
    if conventional_prefix:
        s = s[conventional_prefix.end() :].strip()
    s = re.sub(r"\s+", " ", s)

    # Keep summaries imperative-ish and lowercase initial by convention.
    if s:
        return s[0].lower() + s[1:]
    return f"update related to {semantic_type}"


def build_label(semantic_type: str, scope: str | None, breaking: bool, summary: str) -> str:
    scope_fragment = f"({scope})" if scope else ""
    bang = "!" if breaking else ""
    return f"{semantic_type}{scope_fragment}{bang}: {summary}"


def suggest_for_commit(change_id: str, commit_id: str, subject: str) -> CommitSuggestion:
    files = parse_changed_files(change_id)
    semantic_type, confidence, rationale = classify_type(subject, files)
    scope = detect_scope(files)
    breaking = detect_breaking(subject)
    summary = summarize_subject(subject, semantic_type)
    suggested = build_label(semantic_type, scope, breaking, summary)

    return CommitSuggestion(
        change_id=change_id,
        commit_id=commit_id,
        original=subject,
        suggested=suggested,
        semantic_type=semantic_type,
        scope=scope,
        breaking=breaking,
        confidence=confidence,
        rationale=rationale,
        files=files,
    )


def print_table(suggestions: list[CommitSuggestion]) -> None:
    if not suggestions:
        print("No commits matched the revset.")
        return

    print("change_id  confidence  original")
    print("---------  ----------  --------")
    for item in suggestions:
        print(f"{item.change_id:<9}  {item.confidence:<10}  {item.original}")
        print(f"  -> {item.suggested}")
        print(f"     reason: {item.rationale}")
        if item.files:
            preview = ", ".join(item.files[:4])
            if len(item.files) > 4:
                preview += ", ..."
            print(f"     files: {preview}")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Suggest Conventional Commit labels for commits in a jj revset.",
    )
    parser.add_argument("--revset", default="mutable()", help="Revset to analyze (default: mutable()).")
    parser.add_argument("--limit", type=int, default=40, help="Maximum number of commits to analyze.")
    parser.add_argument("--json", action="store_true", help="Emit JSON instead of a text table.")
    return parser.parse_args()


def main() -> int:
    args = parse_args()

    try:
        commits = parse_log(args.revset, args.limit)
        suggestions = [suggest_for_commit(change_id, commit_id, subject) for change_id, commit_id, subject in commits]
    except RuntimeError as err:
        print(f"Error: {err}", file=sys.stderr)
        return 1

    if args.json:
        print(json.dumps([asdict(item) for item in suggestions], indent=2))
    else:
        print_table(suggestions)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
