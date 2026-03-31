---
name: prd-to-slices
description: Break a local phase PRD in specs/NN-phase-name/PRD.md into tracer-bullet vertical slices, then create GitHub slice issues and matching slice-#<issue-number>.md files once a parent PRD issue exists. Use when user wants to convert a PRD to slices, create implementation tickets, or break down a PRD into work items.
---

# PRD to Slices

Break a local PRD into independently-grabbable vertical slices.

## Process

### 1. Locate the PRD

Ask the user for the phase if it is not already clear, then load `specs/NN-phase-name/PRD.md`.

Phase directories must always use the format `NN-phase-name`, where `NN` is the two-digit creation-order prefix.
Unlike slice numbers, this phase prefix does not map to a GitHub issue number.

If the file does not exist, stop and ask the user to point you to the correct phase or PRD path.

Read the local PRD first. Treat it as the planning source of truth.

### 2. Check parent PRD issue state

Look for a recorded parent issue near the top of the PRD, for example:

- `GitHub Issue: #<number>`

If there is no parent PRD issue yet, you may still draft the slice breakdown and get approval, but you must not create slice GitHub issues or local `slice-#<issue-number>.md` files until a parent PRD issue exists.

If the parent PRD issue is missing, recommend creating it first and ask the user whether to do that now. If the user agrees, create it and record the issue number in `specs/NN-phase-name/PRD.md`. Prefer GitHub app tools when available. If you invoke `gh`, request running it outside the sandbox first.

### 3. Explore the codebase (optional)

If you have not already explored the codebase, do so to understand the current state of the code.

### 4. Draft vertical slices

Break the PRD into tracer-bullet slices. Each slice is a thin vertical slice that cuts through all integration layers end-to-end, not a horizontal slice of one layer.

Slices may be `HITL` or `AFK`:

- `HITL`: requires human interaction such as a design review or architectural decision
- `AFK`: can be implemented and merged without human interaction

Prefer AFK over HITL where possible.

<vertical-slice-rules>
- Each slice delivers a narrow but complete path through every layer that matters
- A completed slice is demoable or verifiable on its own
- Prefer many thin slices over few thick ones
</vertical-slice-rules>

### 5. Quiz the user

Present the proposed breakdown as a numbered list. For each slice, show:

- Title
- Type (`HITL` or `AFK`)
- Blocked by
- User stories covered

Iterate until the user approves the breakdown.

### 6. Materialize approved slices

If the parent PRD issue still does not exist and the user declines to create it, stop after the approved breakdown. Do not create slice issues and do not write numbered slice files.

If the parent PRD issue exists, create slice GitHub issues in dependency order so blockers get real issue numbers first.

After each slice issue is created successfully, write `specs/NN-phase-name/slice-#<issue-number>.md`. The local file should closely match the created issue body and should start with a short traceability header:

- `Parent PRD Issue: #<number>`
- `Slice Issue: #<number>`
- `Type: AFK` or `Type: HITL`
- `Blocked by: ...`
- `User stories: ...`

Prefer GitHub app tools when available. If you invoke `gh`, request running it outside the sandbox first.

<issue-template>
## Parent PRD

#<prd-issue-number>

## What to build

A concise description of this vertical slice. Describe the end-to-end behavior, not layer-by-layer implementation. Reference specific sections of the parent PRD rather than duplicating content.

## Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Blocked by

- Blocked by #<issue-number> (if any)

Or `None - can start immediately` if no blockers.

## User stories addressed

Reference by number from the parent PRD:

- User story 3
- User story 7

</issue-template>

Do not create GitHub slice issues unless a parent PRD issue exists. Do not silently close or modify the parent PRD issue.
