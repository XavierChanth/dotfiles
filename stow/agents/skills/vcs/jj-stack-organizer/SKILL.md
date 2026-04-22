---
name: jj-stack-organizer
description: Analyze a Jujutsu (jj) revision or in-progress stack, infer Conventional Commit labels, and decide when a large mixed revision should be split. Use when a user asks to label jj commits, standardize descriptions, split an oversized changeset, or return one manual command block containing both `jj describe` and `jj split` commands.
---

# JJ Stack Organizer

Inspect jj work read-only and return a single manual command plan. By default, analyze `@` plus its contiguous ancestors whose descriptions are empty or start with `wip:`, label every revision in scope, and only suggest `jj split` for revisions whose own diff is both larger than 1000 changed lines and spread across multiple semantic buckets.

## Workflow

1. If the user names a revision, analyze that revision only.
2. If the user names a revset, analyze that revset.
3. Otherwise, resolve the default scope as `@` plus contiguous ancestors whose first-line descriptions are empty or start with `wip:`.
4. Run [scripts/collect_stack_context.py](./scripts/collect_stack_context.py) to gather revision metadata, diff stats, changed files, label suggestions, suspicious-file warnings, and split recommendations.
5. Audit the output for generated caches, machine-local paths, secrets, build outputs, or other files that likely should not be committed.
6. Infer or refine a Conventional Commit label for every revision in scope.
7. Only plan `jj split` for a revision when both conditions hold:
   - the revision exceeds 1000 changed lines counting insertions plus deletions
   - the revision spans multiple semantic buckets that would produce reviewable commits
8. Keep split buckets ordered from prerequisite refactor to behavior change, then tests, docs, tooling, or polish.
9. Return exactly one fenced `bash` block containing every `jj split` and `jj describe` command in execution order. Do not emit a second command block.
10. Do not include shell comments inside the command block. The block must be pure copy/paste commands only.
11. Do not run mutating jj commands unless the user explicitly asks you to execute them.

## Quick Start

Run the bundled script from the repository whose jj stack you want to inspect:

```bash
python /absolute/path/to/scripts/collect_stack_context.py
```

Inspect a single revision:

```bash
python /absolute/path/to/scripts/collect_stack_context.py --revision @
```

Inspect an explicit revset:

```bash
python /absolute/path/to/scripts/collect_stack_context.py --revset "mutable()"
```

For machine-readable output:

```bash
python /absolute/path/to/scripts/collect_stack_context.py --json
```

## Output Contract

Return results in this shape:

1. A brief diagnosis describing the analyzed scope and whether any revision should be split.
2. A warning section only when suspicious files, stale snapshot mode, or ambiguous split boundaries matter.
3. One fenced `bash` block containing the full manual command plan for every targeted revision.

The command block is mandatory. Keep any prose outside it short.
Do not include shell comments in the command block.

## Command Guidance

- Always include `jj describe -r <rev> -m "<type>(<scope>): <subject>"` for existing revisions that are not being created by a split.
- When splitting, prefer `jj split -r <rev> ... -m "<label>"` so new commits are labeled inline.
- Do not emit standalone `jj describe` for buckets created by `jj split` unless a later relabel is unavoidable.
- Prefer file-based `jj split -r <rev> <path>...` when buckets map cleanly to whole files.
- Prefer `jj split -r <rev> --interactive` when one file mixes multiple semantic buckets.
- Use `jj rebase` or `jj squash` only when the split result clearly requires them, and keep them in the same command block if they are necessary.
- Use double quotes for `-m` values by default. Escape embedded double quotes, and warn if `$` or `!` need shell escaping.

## Label Guidance

- Use Conventional Commit labels with short imperative summaries.
- Prefer `fix`, `feat`, `docs`, `test`, `refactor`, `perf`, `build`, `ci`, `style`, then `chore`.
- Derive scope from the dominant stable subsystem. Collapse paths like `packages/app/...` to `app` and `drivers/scanner/...` to `scanner`.
- Omit scope when the revision intentionally spans unrelated areas.
- Mark breaking changes with `!` only when the description or diff clearly indicates a breaking behavior or API change.

## Split Guidance

- Treat major areas as semantic buckets, not raw path groups.
- Use buckets such as prerequisite refactor, behavior change, tests, docs, tooling or ci, and polish.
- Do not suggest splitting revisions at or below 1000 changed lines.
- Do not suggest splitting a large revision that is still one coherent concern.
- Prefer fewer buckets when a finer split would make the stack harder to review.

Use [references/heuristics.md](./references/heuristics.md) when the split boundary or label type is ambiguous.

## Audit Rules

- Flag files such as `__pycache__/`, `*.pyc`, `.DS_Store`, local caches, build artifacts, credential files, machine-specific symlinks, or generated lockfiles that do not belong in source control.
- If a flagged file appears, call it out before giving the command block.
- Recommend targeted ignore and untrack commands when the file likely should be removed from version control.

Example pattern:

```bash
printf '__pycache__/\n*.pyc\n' >> .gitignore
jj file untrack path/to/file
```

## Guardrails

- Stay read-only by default.
- If the collector reports `snapshot_mode: stale-ignore-working-copy`, warn that unsnapshotted working-copy changes may be missing from the analysis.
- When no revision qualifies for splitting, still return the single command block with only `jj describe` commands.
- When the user asks for execution, return the exact command sequence first and wait for confirmation unless they explicitly want mutating jj commands to run.
