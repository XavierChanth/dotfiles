---
name: issue
description: Explain how to use the GitHub CLI for issue workflows. Use when the user explicitly invokes `/issue` or `$issue` and wants help with `gh issue` commands such as listing, viewing, creating, commenting, editing, closing, or reopening issues.
---

# Issue

Explain GitHub issue workflows with `gh issue`.

This skill is for explicit invocation only. Do not take over general bug triage, PRD-to-issues, refactor RFCs, or issue-authoring flows owned by other skills.

## Default behavior

- Prefer explaining the relevant `gh issue` commands instead of executing them.
- Tailor the response to the user's request and keep examples concrete.
- When helpful, include a short command sequence instead of a long tutorial.

## Commands to cover

Use these as the default toolbox:

- List issues: `gh issue list`
- View an issue: `gh issue view <number>`
- Create an issue: `gh issue create`
- Comment on an issue: `gh issue comment <number> --body "..."`
- Edit an issue: `gh issue edit <number> ...`
- Close an issue: `gh issue close <number>`
- Reopen an issue: `gh issue reopen <number>`

Add useful flags only when they help answer the user's specific request.

## Execution rules

- If the user asks you to run a `gh` command, request running it outside the sandbox before invoking it.
- If credentials are unavailable, authentication fails, or sandbox restrictions prevent the command from working, say that clearly and request running the `gh` command outside the sandbox.
- Do not assume `gh` is authenticated; mention `gh auth status` or `gh auth login` only when relevant to the user's problem.

## Response shape

Keep responses concise and practical:

1. State the command or small set of commands that match the request.
2. Briefly explain what each command does.
3. If execution was requested, note that `gh` should be run outside the sandbox.
