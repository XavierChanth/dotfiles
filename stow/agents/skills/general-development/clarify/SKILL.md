---
name: clarify
description: Restate the user's most recent request so they can confirm the assistant's understanding before work proceeds. Use when the user explicitly invokes `/clarify` or `$clarify`, or asks for clarification with phrases such as "can you clarify, please", "clarify, please", or "can you clarify for me", especially when they want the assistant to reflect their request back because it is ambiguous, dense, or easy to interpret in multiple ways.
---

# Clarify

Use this skill to confirm understanding before acting.

This skill is for clarification, not execution. Do not start solving the task while this skill is active.

## Default behavior

- Restate the user's latest request in your own words.
- Preserve concrete goals, constraints, non-goals, and assumptions already present in the request.
- If multiple interpretations are plausible, call them out explicitly instead of silently picking one.
- End by asking the user to confirm or correct the understanding.

## Response shape

1. Give a short "here is my understanding" restatement.
2. If needed, list the main ambiguities, decision points, or competing interpretations.
3. Ask for confirmation before proceeding.

## Rules

- Prefer paraphrase over quotation.
- Keep the restatement faithful and compact.
- Do not introduce new requirements, designs, or recommendations unless the user asks for them.
- Do not ask a long interview question set. Ask only for the confirmation or correction needed to remove the ambiguity.
- If the request is already clear, keep the confirmation lightweight.
- After the user confirms or corrects the understanding, continue with the task normally.
