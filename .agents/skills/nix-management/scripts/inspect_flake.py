#!/usr/bin/env python3
"""Summarize likely Nix entry points in a repository."""

from __future__ import annotations

import argparse
from pathlib import Path


PATTERNS = (
    "flake.nix",
    "flake.lock",
    "default.nix",
    "shell.nix",
)

KEYWORDS = (
    "darwinConfigurations",
    "nixosConfigurations",
    "homeConfigurations",
    "devShells",
    "packages",
    "checks",
    "overlays",
)


def rel(path: Path, root: Path) -> str:
    return str(path.relative_to(root))


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("path", nargs="?", default=".", help="Repository root to inspect")
    args = parser.parse_args()

    root = Path(args.path).resolve()
    if not root.exists():
        raise SystemExit(f"Path does not exist: {root}")

    nix_files = sorted(
        p for p in root.rglob("*.nix") if ".git" not in p.parts and "result" not in p.parts
    )

    print(f"root: {root}")
    print(f"nix_file_count: {len(nix_files)}")

    special = [p for p in nix_files if p.name in PATTERNS]
    if special:
        print("special_files:")
        for path in special:
            print(f"  - {rel(path, root)}")

    matched_dirs = set()
    for path in nix_files:
        lower_parts = {part.lower() for part in path.parts}
        if lower_parts & {"darwin", "nixos", "home-manager", "home", "hosts", "modules", "overlays", "packages"}:
            matched_dirs.add(path.parent)

    if matched_dirs:
        print("interesting_directories:")
        for directory in sorted(matched_dirs):
            print(f"  - {rel(directory, root)}")

    if not nix_files:
        return 0

    print("keyword_hits:")
    for keyword in KEYWORDS:
        hits = []
        for path in nix_files:
            try:
                text = path.read_text()
            except UnicodeDecodeError:
                continue
            if keyword in text:
                hits.append(rel(path, root))
        if hits:
            print(f"  {keyword}:")
            for hit in hits[:10]:
                print(f"    - {hit}")
            if len(hits) > 10:
                print(f"    - ... {len(hits) - 10} more")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
