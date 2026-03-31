---
name: write-a-prd
description: Create or refine a phase-scoped PRD in specs/NN-phase-name/PRD.md through user interview, codebase exploration, and module design. Optionally create a parent GitHub issue after writing the PRD. Use when user wants to write a PRD, create a product requirements document, or plan a new feature.
---

This skill will be invoked when the user wants to create or refine a PRD.

## Workflow

1. Ask the user which phase this PRD belongs to if the phase is not already clear.

   Phase directories must always use the format `NN-phase-name`, where `NN` is a two-digit prefix representing creation order.
   Unlike slice numbers, this phase prefix does not map to a GitHub issue number.

   - If refining an existing phase, use the existing `specs/NN-phase-name` directory.
   - If creating a new phase, choose the next available two-digit prefix by scanning the existing `specs/` directories and create `specs/NN-phase-name/`.

2. Treat `specs/NN-phase-name/PRD.md` as the source of truth. If it already exists, read it first and refine it instead of overwriting it blindly. If it does not exist, create the phase directory and write a new file there.

3. Explore the repo to verify the user's assertions and understand the current state of the codebase.

4. Interview the user relentlessly about every aspect of the problem and solution until you reach a shared understanding. Walk down each branch of the design tree, resolving dependencies one-by-one.

5. Sketch out the major modules you will need to build or modify. Look for deep modules that can be tested in isolation. Confirm the proposed module boundaries and testing expectations with the user.

6. Write the PRD to the local file first. The file should stay within the selected phase and should use the template below. Keep any existing traceability lines near the top of the file if they are already present:

   - `Phase: NN-phase-name`
   - `GitHub Issue: #<number>` (optional)

7. After writing the PRD, ask whether the user wants to create the parent PRD issue immediately. Do not create it by default.

8. If the user agrees, create the GitHub issue and then record the resulting issue number near the top of `specs/NN-phase-name/PRD.md`. Prefer GitHub app tools when available. If you invoke `gh`, request running it outside the sandbox first.

<prd-template>

## Problem Statement

The problem that the user is facing, from the user's perspective.

## Solution

The solution to the problem, from the user's perspective.

## User Stories

A LONG, numbered list of user stories. Each user story should be in the format of:

1. As an <actor>, I want a <feature>, so that <benefit>

<user-story-example>
1. As a mobile bank customer, I want to see balance on my accounts, so that I can make better informed decisions about my spending
</user-story-example>

This list of user stories should be extremely extensive and cover all aspects of the feature.

## Implementation Decisions

A list of implementation decisions that were made. This can include:

- The modules that will be built or modified
- The interfaces of those modules that will be modified
- Technical clarifications from the developer
- Architectural decisions
- Schema changes
- API contracts
- Specific interactions

Do NOT include specific file paths or code snippets. They may end up being outdated very quickly.

## Testing Decisions

A list of testing decisions that were made. Include:

- A description of what makes a good test (only test external behavior, not implementation details)
- Which modules will be tested
- Prior art for the tests (similar types of tests in the codebase)

## Out of Scope

A description of the things that are out of scope for this PRD.

## Further Notes

Any further notes about the feature.

</prd-template>
