#!/usr/bin/env python3
"""Collect a compact git change summary for commit message generation."""

from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path


MAX_PATCH_LINES = 220


def run_git(repo: Path, *args: str, check: bool = True) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        ["git", *args],
        cwd=repo,
        text=True,
        capture_output=True,
        check=check,
    )


def git_output(repo: Path, *args: str) -> str:
    return run_git(repo, *args).stdout.strip()


def section(title: str, content: str) -> str:
    body = content.rstrip()
    if not body:
        body = "(none)"
    return f"## {title}\n{body}\n"


def ensure_repo(repo: Path) -> Path:
    try:
        top = git_output(repo, "rev-parse", "--show-toplevel")
    except subprocess.CalledProcessError as exc:
        sys.stderr.write(exc.stderr or "Not a git repository.\n")
        raise SystemExit(1) from exc
    return Path(top)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("repo", nargs="?", default=".", help="Path inside the target git repository")
    args = parser.parse_args()

    repo = ensure_repo(Path(args.repo).resolve())

    branch = git_output(repo, "rev-parse", "--abbrev-ref", "HEAD")
    status = git_output(repo, "status", "--short")
    staged_files = git_output(repo, "diff", "--cached", "--name-only")
    unstaged_files = git_output(repo, "diff", "--name-only")
    untracked_files = git_output(repo, "ls-files", "--others", "--exclude-standard")
    staged_stat = git_output(repo, "diff", "--cached", "--stat")
    unstaged_stat = git_output(repo, "diff", "--stat")

    staged_patch = git_output(repo, "diff", "--cached", "--", ".")
    unstaged_patch = git_output(repo, "diff", "--", ".")
    combined_patch = "\n".join(
        part for part in [staged_patch, unstaged_patch] if part.strip()
    ).strip()
    patch_lines = combined_patch.splitlines()
    if len(patch_lines) > MAX_PATCH_LINES:
        combined_patch = "\n".join(patch_lines[:MAX_PATCH_LINES]) + "\n... [truncated]"

    parts = [
        section("Repository", str(repo)),
        section("Branch", branch),
        section("Status", status),
        section("Staged Files", staged_files),
        section("Unstaged Files", unstaged_files),
        section("Untracked Files", untracked_files),
        section("Staged Diff Stat", staged_stat),
        section("Unstaged Diff Stat", unstaged_stat),
        section("Patch Preview", combined_patch),
    ]

    sys.stdout.write("\n".join(parts).rstrip() + "\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
