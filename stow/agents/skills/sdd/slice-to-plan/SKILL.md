---
name: slice-to-plan
description: Load a local slice by issue number, load its sibling PRD, reconcile both with GitHub when available, then use grill-me questioning to produce an implementation plan and update local phase docs. Use when user wants to plan work for a slice issue.
---

# Slice to Plan

Plan implementation for an existing slice.

## Input

The user should only need to give you a slice issue number.

## Resolution order

Always load context in this order:

1. Find the local `specs/**/slice-#<issue-number>.md` file.
2. Load the sibling `specs/NN-phase-name/PRD.md` file from the same phase directory.
3. Try to fetch the matching slice GitHub issue and the parent PRD GitHub issue, including comments.

Phase directories must always use the format `NN-phase-name`, where `NN` is the two-digit creation-order prefix.
Unlike slice numbers, this phase prefix does not map to a GitHub issue number.

If the local slice file is missing, stop and ask the user to point you to the correct phase or slice file. Do not guess the phase from GitHub alone.

If multiple local slice files match the same issue number, stop and ask the user to disambiguate.

If the sibling `PRD.md` file is missing, stop and ask the user to point you to the correct PRD.

Missing GitHub issues are acceptable. GitHub is enrichment, not the primary source of phase selection.

## Reconciliation

Treat the local slice and local PRD as the primary planning context. Use GitHub issues to pull in newer clarifications, comments, or drift that has not made it back into the repo yet.

Look for issue references in the local files first:

- `Slice Issue: #<number>`
- `Parent PRD Issue: #<number>`
- `GitHub Issue: #<number>`

Prefer GitHub app tools when available. If you invoke `gh`, request running it outside the sandbox first.

## Interview

After loading context, follow the behavior of [$grill-me](/Users/chant/.dotfiles/stow/agents/skills/matpocock/grill-me/SKILL.md). Walk through the implementation details until you reach a shared understanding.

If a question can be answered by exploring the repo, explore first instead of asking.

## After the interview

1. Update the local `PRD.md` and the selected `slice-#<issue-number>.md` by default with any clarified details that belong in those docs.
2. Keep all edits within the same phase.
3. Do not silently rewrite sibling slice files. If the new information clearly affects other slices in the same phase, call out the recommended follow-up edits explicitly.
4. Return a concrete implementation plan in chat.
5. If GitHub issue data was available, recommend syncing the local documentation updates back to the corresponding GitHub issues and ask before doing it.

You do not need to invoke `$issue` for this workflow. Fetch issue content directly.
