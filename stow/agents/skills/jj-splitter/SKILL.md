---
name: jj-splitter
description: Analyze a Jujutsu (jj) revision diff and propose how to split it into like-work commits ordered from prerequisite work to dependent work, with commit messages embedded directly in the split commands. Use when a user asks to split a messy jj change, separate refactor from feature work, reorganize a revision, or produce non-interactive split-and-label commands in one pass before rewriting history.
---

# JJ Splitter

Inspect one `jj` revision at a time and return a read-only split-and-label plan. The skill groups changes by intent, recommends an ordering that puts prerequisite work first, and suggests manual `jj` commands without executing them.

## Workflow

1. Default to revision `@` unless the user names another revision.
2. Run [`collect_split_context.py`](./scripts/collect_split_context.py) to gather normalized revision metadata, changed files, and patch context.
3. Audit the changed files for generated caches, machine-local paths, secrets, build outputs, or other files that likely should not be committed.
4. If suspicious files appear, flag them before planning the split and recommend `gitignore` plus untrack commands when appropriate.
5. Decide whether the revision should stay intact or be split at all.
6. Group the diff into like-work buckets by intent, not only by path.
7. Order buckets so prerequisites land before behavior changes, then tests, then docs or polish.
8. Generate a Conventional Commit label for each planned bucket.
9. Return the final command sequence as a single copy-pasteable shell block, embedding each label directly into the relevant `jj split -m` command so the workflow stays non-interactive. Do not run mutating `jj` commands unless the user explicitly asks.

## Quick Start

Run the bundled script from the repository whose `jj` revision you want to inspect:

```bash
python /absolute/path/to/scripts/collect_split_context.py --revision @
```

For machine-readable output:

```bash
python /absolute/path/to/scripts/collect_split_context.py --revision @ --json
```

## Output Contract

Return results in this shape:

1. A brief diagnosis stating whether the revision should be split and why.
2. Proposed buckets with short names, rationale, and the files or hunks that belong in each bucket.
3. Recommended ordering from prerequisite to dependent work.
4. One fenced shell block containing the exact manual `jj` commands needed to produce the planned buckets, with `-m` labels embedded directly in the relevant split commands.
5. A short warning section only when the split is ambiguous, lossy, likely to require manual hunk selection, or contains files that likely should not be committed.

If the diff appears to be one coherent concern, say not to split it.

## Grouping Rules

- Group by intent before path. Prefer categories such as prerequisite refactor, mechanical cleanup, behavior change, tests, docs, or follow-up polish.
- Keep generated files, lockfiles, and purely mechanical renames with the change that requires them unless they are clearly independent.
- Treat docs and tests as separate buckets only when they can stand alone without obscuring the main behavioral change.
- Avoid inventing buckets with no clear boundary in the diff.

Use [references/heuristics.md](./references/heuristics.md) when the grouping or ordering is ambiguous.

## Command Guidance

- Prefer file-based `jj split -r <rev> <path>...` when a bucket maps cleanly to whole files.
- Prefer `jj split -r <rev> --interactive` when one file mixes multiple intents.
- Use `jj rebase` only after the split when the resulting commit order still needs prerequisite work moved earlier.
- Use `jj squash` only to fold a small follow-up or accidentally isolated hunk back into the right bucket.
- Do not output commands that depend on hidden assumptions about change IDs. Use placeholders such as `<rev>` or named buckets when needed.
- When the split is clear, emit one fenced `bash` block that the user can copy and paste as-is.
- When using `jj split`, pass `-m "<label>"` so the selected commit is labeled without opening an editor.
- Do not emit separate `jj describe` commands for buckets created by `jj split`; that makes the workflow more interactive than necessary.
- Inside the command block, place split or reorder commands in the order they should be run.

## Describe Guidance

- Prefer embedding labels directly in `jj split -m` instead of emitting separate `jj describe` commands.
- Only use standalone `jj describe` when a label must be applied to an existing commit that is not being created by the split sequence.
- Use Conventional Commit labels with short imperative summaries.
- Prefer `feat`, `fix`, `docs`, `test`, `refactor`, `perf`, `build`, `ci`, `style`, then `chore` as fallback.
- Derive scope from the dominant top-level path when it is clear and stable. Omit scope when the bucket spans multiple unrelated areas.
- Do not execute `jj describe`; return commands only.

## Audit Rules

- Flag files such as `__pycache__/`, `*.pyc`, `.DS_Store`, local caches, build artifacts, credential files, and machine-specific symlinks or generated locks that do not belong in source control.
- If a flagged file appears, call it out before giving split commands.
- Recommend targeted ignore and untrack commands when the file likely should be removed from version control.

Example pattern:

```bash
printf '__pycache__/\n*.pyc\n' >> .gitignore
jj file untrack path/to/file
```

## Guardrails

- Stay read-only by default.
- If the collector reports `snapshot_mode: stale-ignore-working-copy`, warn that unsnapshotted working-copy changes may be missing from the analysis.
- Call out when the patch does not provide enough signal to separate refactor from feature work confidently.
- Prefer fewer commits when a finer split would make the stack harder to understand.
- Prefer returning one copy-pasteable command block over prose when the split is clear.
- When the user asks for execution, provide the exact command sequence first and wait for confirmation unless they explicitly want you to run mutating `jj` commands.
