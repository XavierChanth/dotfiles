# JJ Stack Organizer Heuristics

## Label Priority

1. `fix` for bug, error, regression, crash, revert, or corrective wording.
2. `feat` for new capability or explicit support.
3. `docs` for documentation-only changes.
4. `test` for test-only changes.
5. `refactor` for structural cleanup without behavior change.
6. `perf` for explicit performance work.
7. `build` for dependency, packaging, or toolchain changes.
8. `ci` for workflow or automation changes.
9. `style` for formatting or lint-only work.
10. `chore` as fallback when the signal is weak.

## Scope Extraction

- Prefer the dominant top-level subsystem from changed files.
- Collapse package containers to a stable subsystem:
  - `packages/app/...` -> `app`
  - `drivers/scanner/...` -> `scanner`
  - `modules/shared/...` -> `shared`
- Omit scope when no dominant subsystem exists.

## Semantic Buckets

- `prerequisite refactor`: extraction, move-only edits, rename-heavy cleanup, internal API shaping
- `behavior change`: new features, bug fixes, validation changes, CLI or UI behavior changes
- `tests`: test-only additions or updates
- `docs`: README, comments, docs pages, examples
- `tooling`: flake, package manager, formatter, build, or CI workflow changes
- `polish`: style-only cleanup or follow-up mechanical cleanup

## Split Gate

- Only consider splitting when a revision exceeds 1000 changed lines counting insertions plus deletions.
- Only recommend splitting when the revision also spans multiple semantic buckets with boundaries that can be reviewed separately.
- Large size alone is not enough.
- Mixed files within one semantic bucket may still stay intact.

## Ordering

Use this default bucket order unless the patch clearly argues otherwise:

1. prerequisite refactor
2. behavior change
3. tests
4. docs
5. tooling
6. polish

## Warning Signals

- The same file mixes prerequisite refactor and behavior edits.
- Generated outputs change alongside their sources.
- Renames and follow-up behavior edits are interleaved in the same hunks.
- The diff is large but still reads as one coherent concern.
- The revision contains suspicious files that likely should not be committed.
