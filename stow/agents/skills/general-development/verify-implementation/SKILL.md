---
name: verify-implementation
description: Verify an implementation against requirements that are already in context, then do an edge-case and risk pass. Use when the user asks to verify work, review whether an implementation meets requirements, or do an acceptance pass before shipping.
---

# Verify Implementation

Use this skill when the question is "does this implementation satisfy the intended behavior?" Assume the requirements are already available in context. Keep the review anchored to those requirements. Do not start with style opinions, redesign ideas, or a fresh discovery interview.

## 1. Start From the Requirements in Context

Before judging the implementation, identify the requirements that are already present in context and turn them into a short checklist in your notes.

You should explicitly outline these requirements in your response before giving a verdict. The reader should be able to see exactly what standard the implementation is being judged against.

Separate them into:

- Explicit requirements
- Constraints and non-goals
- Assumptions that are already implicit in the request or spec

Do not spend time gathering more requirements unless the existing context is too ambiguous to support a meaningful verdict. If requirements conflict, surface the conflict instead of silently choosing one interpretation.

## 2. Validate Against Requirements

Check the implementation requirement by requirement.

For each requirement:

- Find the relevant code paths, config, migrations, tests, and docs
- Decide whether it is satisfied, partially satisfied, not satisfied, or cannot be verified yet
- Prefer direct evidence such as code paths, tests, runtime checks, or command output
- Call out when a conclusion is an inference rather than something you directly verified

As part of this pass, outline what appears to have been implemented:

- Summarize the relevant behavior, code paths, and tests you found
- State what the implementation currently does, not what it seems intended to do
- Keep this grounded in evidence from the codebase or execution

When validation would benefit from execution, run the narrowest useful checks first:

- Targeted tests
- Build or typecheck
- Lint only if it provides signal for the requirement at hand
- Manual local inspection for UI or workflow changes

Do not stop at "the code looks plausible." Trace the behavior end to end.

## 3. Edge-Case and Risk Pass

After the requirements pass, do a second pass for things the requirements may not mention explicitly.

Look for:

- Boundary conditions and empty states
- Invalid input and error handling
- Partial failure and rollback behavior
- Concurrency, async ordering, or race conditions
- Auth, permissions, and data exposure risks
- Platform, config, and environment differences
- Accessibility, performance, and observability gaps
- Missing or misleading tests
- Regressions against nearby established patterns

This pass should expand confidence, not invent a different product. Keep "worth considering" items clearly separate from confirmed requirement misses.

## 4. Report Findings

Default to review mode:

- Start by stating the requirements being validated
- Then summarize what was implemented
- Findings first, ordered by severity
- Include file and line references when possible
- Distinguish confirmed defects from open questions or lower-confidence risks
- If no findings are discovered, say so explicitly and mention residual risks or missing validation

A good final structure is:

1. Requirements being validated
2. What was implemented
3. Confirmed requirement misses or changes needed
4. Edge cases and risks worth considering
5. Brief summary of what was verified and what was not
