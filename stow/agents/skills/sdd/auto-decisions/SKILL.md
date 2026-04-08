---
name: auto-decisions
description: Automatically log material SDD decisions as they happen. Record user-made decisions in `spec/user-decisions.md` or `spec/<scope>/user-decisions.md`, and agent-made decisions in `spec/auto-decisions.md` or `spec/<scope>/auto-decisions.md`, choosing the narrowest clear scope. Use whenever SDD work involves material decisions, even if the user did not explicitly ask for decision logging.
---

# Auto Decisions

Use this skill when SDD work should keep moving while decision history stays audit-friendly.

This is an execution mode for SDD work, not a replacement for the underlying planning or implementation skill.

## Scope resolution

Resolve the narrowest clear spec scope before logging any decision.

Use the strongest signal available:

1. An explicit scoped spec directory such as `spec/xx-foo-bar`
2. A referenced `PRD.md`, `slice-#<issue-number>.md`, or similar spec doc that already lives in a specific spec directory
3. Traceability lines or nearby file paths that clearly tie the work to one specific spec directory
4. If no specific scope is clearly established, fall back to the root `spec/` scope

Routing rule:

- If a decision is clearly about one specific area, log it in that area's directory, for example `spec/xx-foo-bar/`
- If a decision is broad, vague, cross-cutting, or not yet attached to one clear area, log it at the root `spec/`
- Do not duplicate the same decision at both root and specific scope unless the user explicitly asks for duplication

If multiple specific scopes plausibly match and the decision is not clearly broad enough for the root log, stop and ask the user to disambiguate.

## Decision files

At each scope, there are up to two decision files:

- `spec/user-decisions.md` or `spec/<scope>/user-decisions.md`
- `spec/auto-decisions.md` or `spec/<scope>/auto-decisions.md`

Create a file only when you have at least one material entry for it. Never create empty decision files.

If a target file already exists, read it before appending new entries.

Do not create both files at a scope unless both types of decisions actually occurred there.

## Working mode

1. Explore the repo and load the relevant spec docs first.
2. Treat decision logging as continuous, not end-of-task cleanup.
3. Every time a material decision is established, append it immediately to the correct decision file so the log does not depend on memory.
4. Continue the task normally instead of stopping to present option menus for routine choices, unless the decision is high risk.
5. At the end of the task, point the user to each decision file that was updated.

Route entries by who made the decision:

- `user-decisions.md`: decisions explicitly made by the user, explicitly confirmed by the user, or jointly discussed and then approved by the user
- `auto-decisions.md`: decisions the agent made autonomously while moving the work forward

Do not mirror the same decision into both files. If the user chose the high-level direction and the agent later made an additional material implementation choice within that direction, log those as separate entries in their respective files.

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

Do not log facts that were merely copied into specs or implementation without any actual decision being made.

## What not to log

Do not record:

- Trivial edits with no lasting product or maintenance impact
- Pure status notes, summaries, or progress updates
- Facts copied from the specs without an actual choice
- The same decision in multiple files unless the user explicitly wants duplication

## When to still interrupt the user

Logging is not a substitute for approval when the decision is high risk.

Stop and ask instead of auto-deciding when the choice could:

- Delete or irreversibly rewrite user data
- Change production infrastructure, billing, secrets, or security posture
- Conflict with explicit requirements already given by the user
- Need a specific scope but multiple plausible scoped directories match
- Require using external historical sources such as another branch when approval has not been granted

## Entry format

Append entries in chronological order. Separate entries with a line containing exactly three dashes:

```md
## Decision: <short title>
Date: YYYY-MM-DD
Related: <spec path, PRD, slice, or task context>

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

Keep each entry compact but specific. If no serious alternatives were considered, keep `### Alternatives` brief and say so directly.

If a later decision supersedes an earlier one, append a new entry instead of deleting history. Make the supersession explicit in the new entry.

### Examples

Log:

- In `spec/user-decisions.md`: "The user wants root-scoped decisions when the work is still vague."
- In `spec/xx-foo-bar/auto-decisions.md`: "I kept the first backend behind an adapter until implementation evidence justifies migration."

Do not log:

- "Renamed a variable for clarity."
- "Opened the PRD and reviewed it."

## Output

At the end of the task:

1. Summarize the work completed
2. Link the user to each updated decision file, for example `spec/user-decisions.md` or `spec/xx-foo-bar/auto-decisions.md`
3. Call out any decisions that still look especially worth human review
