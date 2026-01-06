---
description: Generate PR body from trunk() to @ diff with highlights and context
model: opus
---

You are tasked with generating a pull request body based on the changes between the jj revsets `trunk()` and `@`.

Follow these steps:

1. **Gather commit information:**
   - Run `jj log -r 'trunk()..@'` to get all commits in this change
   - Run `jj diff --from trunk() --to @` to get the full diff

2. **Analyze the changes:**
   - Review all commit descriptions to understand the narrative of what was done
   - Analyze the diff to identify key technical changes
   - Determine the "why" behind changes when evident from context (e.g., bug fixes, new features, refactoring)

3. **Generate PR body with this structure:**

```markdown
## Summary
[2-4 sentence overview of what this PR accomplishes]

## Changes
[Bulleted list of key changes, organized by type if applicable:]
- **Feature:** [description]
- **Fix:** [description]
- **Refactor:** [description]
- **Docs:** [description]

## Technical Details
[Optional section for important implementation notes, architectural decisions, or context about why certain approaches were taken]

## Testing
[If tests were added/modified, describe what was tested]

---
Generated with [Claude Code](https://claude.com/claude-code)
```

4. **Important guidelines:**
   - Focus on the "what" and "why", not the "how" (unless the how is architecturally significant)
   - Use present tense ("Adds feature" not "Added feature")
   - Be concise but comprehensive - capture all significant changes
   - If commits have detailed descriptions, incorporate that context
   - If changes are simple, keep the PR body simple - don't over-explain
   - Group related changes together

5. **Output the PR body:**
   - Return ONLY the markdown PR body text
   - Do NOT include any commentary outside the PR body itself

Begin by running the jj commands to gather the necessary information.
