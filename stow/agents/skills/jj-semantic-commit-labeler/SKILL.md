---
name: jj-semantic-commit-labeler
description: Analyze Jujutsu (jj) commit history and propose Conventional Commit labels (type, optional scope, optional breaking marker) for each commit. Use when a user asks to classify, rewrite, or standardize jj commit messages, especially before squashing, rebasing, or polishing a patch stack.
---

# JJ Semantic Commit Labeler

## Workflow

1. Collect candidate commits from the requested revset (default: `mutable()` for in-progress work).
2. For each commit, inspect the first-line description and changed file paths.
3. Audit the changed files for generated caches, machine-local paths, secrets, build outputs, or other files that likely should not be committed.
4. If suspicious files appear, flag them before suggesting labels and recommend `gitignore` plus untrack commands when appropriate.
5. Infer a Conventional Commit label: `type(scope)!: summary`.
6. Present suggestions with confidence and short rationale.
7. Ask for confirmation, then output `jj describe` commands for the user to run.
8. Skip generating `jj describe` commands for empty commits or commits that already have a non-empty description.

## Quick Start

Run the bundled script from the repository whose jj graph you want to analyze:

```bash
python /absolute/path/to/scripts/suggest_semantic_labels.py --revset "mutable()" --limit 40
```

For machine-readable output:

```bash
python /absolute/path/to/scripts/suggest_semantic_labels.py --json
```

## Editing Commit Messages

After selecting labels, provide `jj describe` commands per revision and let the user execute them.

Example pattern:

```bash
jj describe -r <change-id> -m "feat(scanner): improve frame buffering"
```

Prefer one commit at a time unless the user explicitly requests a batch rewrite.

Default behavior: do not execute `jj describe` automatically because commit signing may require unavailable SSH keys in this environment.
When generating commands, omit empty commits and commits that are already described.

## Audit Rules

- Flag files such as `__pycache__/`, `*.pyc`, `.DS_Store`, local caches, build artifacts, credential files, and machine-specific symlinks or generated locks that do not belong in source control.
- If a flagged file appears, call it out before giving label suggestions.
- Recommend targeted ignore and untrack commands when the file likely should be removed from version control.

Example pattern:

```bash
printf '__pycache__/\n*.pyc\n' >> .gitignore
jj file untrack path/to/file
```

## Heuristics

Use these type priorities (high to low confidence):

1. `fix` for bug/error/corrective wording.
2. `feat` for new capabilities.
3. `docs` for documentation-only changes.
4. `test` for test-only changes.
5. `refactor` for structural code cleanup without behavior change.
6. `perf` for performance work.
7. `build` for dependency/build packaging changes.
8. `ci` for pipeline/workflow automation.
9. `style` for lint/format-only edits.
10. `chore` as fallback.

Derive `scope` from the dominant top-level path (for example `packages/app` -> `app`, `drivers/scanner` -> `scanner`).

Mark breaking changes with `!` only when text clearly indicates a breaking API/behavior change.

## Resources

- Use [references/heuristics.md](references/heuristics.md) for keyword rules.
- Use [scripts/suggest_semantic_labels.py](scripts/suggest_semantic_labels.py) to generate first-pass labels quickly.
