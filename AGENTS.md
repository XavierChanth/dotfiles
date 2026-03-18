# AGENTS.md

This repository is a new port of the dotfiles setup. Treat it as the source of truth.

## Working Rules

- Prefer adapting and extending the configuration in this repo instead of assuming the old setup should be copied over.
- When configuring tools, it can sometimes be helpful to reference the `v1` branch in this repo as historical context.
- Always ask the user before pulling, copying, or otherwise using config from the `v1` branch.
- Keep changes aligned with the current Nix-based structure unless the user asks for a broader redesign.

## Repo Shape

- `flake.nix` and `flake.lock`: flake entrypoint and pinned inputs.
- `hosts/darwin/nyx/default.nix`: host-specific darwin configuration.
- `home/chant/default.nix`: Home Manager user configuration.
- `modules/shared/*.nix`: shared tool and package modules.
- `modules/darwin/defaults.nix`: darwin-specific defaults.

## Change Approach

- Make focused edits that match the existing module layout.
- Prefer adding or updating the relevant shared or host module over introducing ad hoc files.
- If a tool is not configured yet and the `v1` branch may be useful as reference, pause and ask first.
