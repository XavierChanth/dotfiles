# JJ Splitter Heuristics

## Bucket Taxonomy

- `prerequisite refactor`: extraction, renames, move-only edits, API shaping, helper creation, internal cleanup required by later behavior changes
- `mechanical cleanup`: formatting, comment cleanup, import sorting, naming cleanup with no behavior change
- `behavior change`: new features, bug fixes, validation changes, CLI/UI behavior updates
- `tests`: test-only additions or updates
- `docs`: README, comments, docs pages, examples
- `polish`: follow-up cleanup that is not required for correctness

## Ordering Priority

Use this default order unless the patch clearly argues otherwise:

1. prerequisite refactor
2. mechanical cleanup that simplifies later review
3. behavior change
4. tests
5. docs
6. polish

If tests are required to make the refactor safe or understandable, keep them adjacent to the bucket they validate.

## Choosing Split Mechanics

- Start with file-based splitting when each bucket owns distinct files.
- Switch to interactive splitting when a file mixes prerequisite and dependent work.
- Avoid splitting purely because the diff is large. Split only when the resulting commits become easier to review, reorder, or describe.
- If a change is tightly coupled across files and cannot be understood separately, prefer one commit.

## Labeling After Split

- Label each planned bucket immediately after deciding its final position in the stack.
- Prefer `refactor` for prerequisite cleanup, `feat` for new behavior, `fix` for corrective behavior, `test` for test-only buckets, and `docs` for documentation-only buckets.
- Use `chore` only when no stronger semantic type fits.
- Keep summaries short and imperative. Avoid repeating path names that are already clear from scope.
- Derive scope from the dominant top-level path or stable subsystem name. Omit scope when the bucket intentionally crosses subsystem boundaries.

## Warning Signals

- The same file contains API extraction plus feature behavior.
- Generated outputs change alongside their sources.
- Renames and follow-up behavior edits are interleaved in the same hunks.
- Tests fail to map clearly to one bucket.
- The revision message already describes a single coherent change.
