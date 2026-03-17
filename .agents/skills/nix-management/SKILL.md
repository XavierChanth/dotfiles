---
name: nix-management
description: Manage Nix flakes, NixOS or nix-darwin configurations, Home Manager setups, package overlays, dev shells, and lockfiles. Use when Codex needs to inspect or modify `flake.nix`, `flake.lock`, `*.nix`, `home-manager`, `nixos`, `darwin`, `overlays`, `packages`, `checks`, or `devShells`, and when validating changes with `nix flake check`, `nix build`, `nix develop`, `home-manager`, `darwin-rebuild`, or `nixos-rebuild`.
---

# Nix Management

## Overview

Use this skill to make safe, targeted changes in Nix-based repositories. Start by discovering how the flake is structured, then choose the narrowest validation command that proves the requested change works before attempting any rebuild or switch step.

## Quick Start

1. Inspect the repo layout before editing. Look for `flake.nix`, `flake.lock`, host or user modules, overlays, packages, `checks`, and `devShells`.
2. Confirm the requested scope. Avoid changing unrelated modules, formatting, or lockfile pins unless the user asked for that.
3. Make the smallest viable Nix edit.
4. Validate with the least risky command that still exercises the change.
5. Only run `switch`, `boot`, or lockfile updates when the user asked for them or the task clearly requires them.

Use [`references/workflows.md`](references/workflows.md) for command selection and validation patterns. Use [`scripts/inspect_flake.py`](scripts/inspect_flake.py) to summarize the local repo structure quickly.

## Workflow

### 1. Inspect first

Prefer fast local inspection before running Nix commands:

- Use `rg --files` to find `*.nix`, `flake.nix`, and `flake.lock`.
- Use `rg -n` for `darwinConfigurations`, `nixosConfigurations`, `homeConfigurations`, `devShells`, `packages`, `checks`, and `overlays`.
- Run `python3 scripts/inspect_flake.py <repo>` when you need a quick inventory of likely entry points.

If `flake.nix` is missing, adapt to a non-flake workflow instead of forcing flake commands.

### 2. Edit conservatively

- Preserve existing structure and style.
- Prefer modifying the nearest module that owns the behavior instead of centralizing unrelated logic.
- Avoid reformatting broad sections unless it is necessary for correctness or the repo already enforces formatting.
- Avoid updating `flake.lock` unless the task explicitly involves input versions or a command regenerates it as a required side effect.

### 3. Pick the right validation

Choose the smallest command that proves the change:

- For syntax or evaluation confidence across the flake, prefer `nix flake check`.
- For a package or derivation change, prefer `nix build` on the specific output.
- For shell changes, prefer `nix develop` or `nix develop -c <command>`.
- For Home Manager changes, prefer `home-manager build` before `home-manager switch`.
- For nix-darwin changes, prefer `darwin-rebuild build --flake ...` before `darwin-rebuild switch`.
- For NixOS changes, prefer `nixos-rebuild build --flake ...` before `nixos-rebuild switch` or `boot`.

If a high-impact rebuild is the only meaningful validation, say so explicitly before running it.

### 4. Handle failures deliberately

- Read the first real evaluation error before changing code again.
- Distinguish syntax errors, missing attributes, wrong system names, infinite recursion, and option collisions.
- If the repo depends on secrets, private inputs, or machine-specific paths, explain the limitation and validate as far as the environment allows.

## Safety Rules

- Never run `nix flake update` or `nix flake lock --update-input` unless the user requested dependency updates.
- Never run `*-rebuild switch`, `home-manager switch`, or other live-apply commands unless the user asked to apply the change.
- Prefer `build` or `check` over `switch`.
- Call out when a command may download dependencies, rebuild many derivations, or mutate the working tree.
- Keep edits minimal in shared flake repos because one change can affect multiple hosts or users.

## Common Tasks

### Add or update a package

Find whether the package belongs in a host module, Home Manager module, overlay, or custom package set. Validate with a targeted build or the closest config build command.

### Modify a dev shell

Inspect `devShells` outputs and any shell helpers. Validate with `nix develop` and a lightweight command that proves the tool is present.

### Fix an attribute or option error

Trace the attribute path from the failing command back to the flake output or module that owns it. Prefer correcting the path or option merge logic over rewriting adjacent modules.

### Update a pinned input

Only do this when requested. Update the smallest relevant input, inspect the resulting `flake.lock` diff, and rerun the narrowest validation that exercises the affected outputs.

## References

- Read [`references/workflows.md`](references/workflows.md) for command patterns, decision points, and troubleshooting cues.
