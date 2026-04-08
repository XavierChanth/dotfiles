---
name: auto-decisions
description: Run phase-scoped SDD work autonomously, make reasonable implementation decisions without stopping for option review, and record each material decision plus rejected alternatives in `specs/NN-phase-name/decisions.md` for later human review. Use when the user wants the agent to keep moving, defer decision review until after the work is complete, or maintain a decision log for a specific phase or slice.
---

# Auto Decisions

Use this skill when the user wants forward progress without repeated plan-and-approval pauses.

This is an execution mode for SDD work, not a replacement for the underlying planning or implementation skill.

## Scope resolution

Resolve the target phase before logging any decisions.

Use the strongest signal available:

1. An explicit phase path such as `specs/NN-phase-name`
2. A referenced `PRD.md` in a phase directory
3. A referenced `slice-#<issue-number>.md` in a phase directory
4. Traceability lines already present in local spec files, such as:
   - `Phase: NN-phase-name`
   - `Parent PRD Issue: #<number>`
   - `Slice Issue: #<number>`

Phase directories must always use the format `NN-phase-name`, where `NN` is the two-digit creation-order prefix.
Unlike slice numbers, this phase prefix does not map to a GitHub issue number.

If multiple plausible phases match, stop and ask the user to disambiguate.

If no phase can be resolved, stop and ask the user to point you to the correct phase or spec path. Do not guess.

## Decision log location

Use exactly one decision log per phase:

- `specs/NN-phase-name/decisions.md`

If the file already exists, read it first before appending new entries.

Do not create an empty `decisions.md`. Create it only when at least one material decision needs to be recorded.

## Working mode

1. Explore the repo and load the relevant phase docs first.
2. Execute the task normally instead of stopping to present option menus for routine implementation choices.
3. When a material decision is required, choose the best reasonable option from the available evidence and continue working.
4. Append the decision to `specs/NN-phase-name/decisions.md` as soon as the decision is made so the log does not depend on memory.
5. At the end of the task, point the user to the phase `decisions.md` file for review.

## What counts as a material decision

Record decisions that a human would likely want to audit later, including:

- Architecture or module-boundary choices
- Data model, schema, or API contract choices
- Dependency or tool selection
- Tradeoffs between competing implementation approaches
- Test strategy choices that materially affect confidence or coverage
- Scope cuts, deferrals, or simplifying assumptions
- Behavior changes that are not obvious from the original request

Do not log trivial formatting, naming, or mechanical refactors unless they carry lasting product or maintenance impact.

## When to still interrupt the user

Logging is not a substitute for approval when the decision is high risk.

Stop and ask instead of auto-deciding when the choice could:

- Delete or irreversibly rewrite user data
- Change production infrastructure, billing, secrets, or security posture
- Conflict with explicit requirements already given by the user
- Affect multiple phases and no safe single-phase interpretation exists
- Require using external historical sources such as another branch when approval has not been granted

## Entry format

Append entries in chronological order. Separate entries with a line containing exactly three dashes:

```md
## Decision: <short title>
Date: YYYY-MM-DD
Related: <slice, PRD, or task context>

### Chosen
<the decision that was made>

### Alternatives
- <alternative 1>
- <alternative 2>

### Why
<brief rationale and key tradeoff>

### Impact
- <follow-up implication>
- <important constraint or consequence>
```

Keep each entry compact but specific.

If a later decision supersedes an earlier one, append a new entry instead of deleting history. Make the supersession explicit in the new entry.

## Output

At the end of the task:

1. Summarize the work completed
2. Link the user to `specs/NN-phase-name/decisions.md`
3. Call out any decisions that still look especially worth human review
