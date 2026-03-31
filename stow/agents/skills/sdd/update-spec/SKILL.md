---
name: update-spec
description: Refine existing PRD and slice spec files with newly established design information. Infer scope from the current conversation, update the directly affected local docs first, and optionally recommend syncing linked GitHub issues afterward. Specs live under phase directories named `NN-phase-name`. Use when the user asks to update specs after elaborating on a design.
---

# Update Spec

Use this skill when new design information has been established and the existing spec docs should be brought up to date.

This is a refinement workflow, not a creation workflow.

## Scope resolution

Infer the target docs from the current conversation first.

Use the strongest scope signal available:

1. A referenced slice issue number, slice file, or slice title
2. A referenced phase or `specs/NN-phase-name/PRD.md`
3. Traceability lines already present in local docs, such as:
   - `Phase: NN-phase-name`
   - `GitHub Issue: #<number>`
   - `Parent PRD Issue: #<number>`
   - `Slice Issue: #<number>`

Phase directories must always use the format `NN-phase-name`, where `NN` is the two-digit creation-order prefix.
Unlike slice numbers, this phase prefix does not map to a GitHub issue number.

Default behavior:

- If a slice is in context, update that slice and its sibling `PRD.md`
- If only a phase or PRD is in context, update the phase `PRD.md` and only the slice files explicitly implicated by the new information
- If multiple plausible files match, stop and ask the user to disambiguate

## Local-first workflow

1. Load the existing local spec files first. Treat them as the source of truth to edit.
2. Apply only the newly established information from the current conversation. Do not re-author the whole spec from scratch.
3. Preserve existing traceability lines near the top of each file.
4. Keep all edits within the resolved phase.
5. Make the affected sections more precise instead of appending loose notes whenever possible.

## Edit breadth

Update only the directly affected docs by default:

- Update the active `PRD.md`
- Update the directly relevant slice files in the same phase

Do not silently rewrite unrelated sibling slices. If the new information likely affects other slices in the same phase, call out the recommended follow-up edits explicitly.

## Missing-doc behavior

Do not create missing PRDs or slice files in this workflow.

If the relevant local PRD does not exist, stop and direct the user to [$write-a-prd](/Users/chant/.dotfiles/stow/agents/skills/sdd/write-a-prd/SKILL.md).

If the relevant slice file does not exist yet, stop and direct the user to [$prd-to-slices](/Users/chant/.dotfiles/stow/agents/skills/sdd/prd-to-slices/SKILL.md).

## GitHub behavior

GitHub is optional enrichment and sync, not the primary editable source.

If linked GitHub issues are useful and available, read them to detect drift or newer clarifications. Prefer GitHub app tools when available. If you invoke `gh`, request running it outside the sandbox first.

After updating the local docs, recommend syncing the corresponding GitHub issues and ask before doing it.

## Output

At the end of the workflow:

1. Summarize which local spec files were updated
2. Note any recommended follow-up edits for other files in the same phase
3. State whether linked GitHub issues should be synced
