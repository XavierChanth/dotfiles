---
name: semantic-commit-message
description: Generate a Conventional Commit or semantic commit message suggestion from the current git changes in the active repository. Use when the user wants a commit message based on staged, unstaged, or untracked changes, especially in the current session or thread, and wants the message returned as plain text rather than executed as a git command.
---

# Semantic Commit Message

Inspect the current repository state and return a concise Conventional Commit suggestion as plain text.

## Workflow

1. Confirm the current working directory is inside a git repository.
2. Run `scripts/collect_git_context.py` from this skill, passing the repository path if needed.
3. Read the script output to understand:
   - branch name
   - staged file list
   - unstaged file list
   - untracked file list
   - compact staged and unstaged diff stats
   - a truncated patch preview for changed files
4. Infer the most appropriate Conventional Commit `type` from the actual change intent.
5. Add a scope only when one is clearly helpful and short.
6. Return the commit message as a response. Do not run `git commit`.

## Output Rules

- Return a single-line commit message first, in Conventional Commit format.
- Prefer `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `perf`, `build`, `ci`, or `style`.
- Keep the summary short, specific, and imperative.
- Use lowercase for the type and scope.
- Do not add a trailing period.
- If the diff contains mixed concerns, choose the dominant user-facing change and mention the ambiguity briefly after the suggestion.
- If there are no meaningful changes, say that there is not enough diff context to suggest a commit message yet.

## Heuristics

- Prefer `feat` for net-new behavior or user-visible capability.
- Prefer `fix` for bug fixes, regressions, validation corrections, or guardrails.
- Prefer `refactor` for structural changes without user-visible behavior changes.
- Prefer `docs` for documentation-only edits.
- Prefer `test` for test-only changes.
- Prefer `chore` for maintenance, dependency updates, or housekeeping that does not fit better elsewhere.
- Prefer `build` or `ci` only for tooling or pipeline-specific changes.
- Prefer `perf` only when the diff clearly improves performance.

## Script

Use [`collect_git_context.py`](./scripts/collect_git_context.py) to gather a stable summary of the current repo changes before writing the message.
