# AGENTS.md

This repository is a new port of the dotfiles setup. Treat it as the source of truth.

## Working Rules

- Prefer adapting and extending the configuration in this repo instead of assuming the old setup should be copied over.
- When configuring tools, it can sometimes be helpful to reference the `v1` branch in this repo as historical context.
- Always ask the user before pulling, copying, or otherwise using config from the `v1` branch.
- Keep changes aligned with the current Nix-based structure unless the user asks for a broader redesign.
- Prefer reproducible, cross-machine configuration. Do not hardcode machine-specific paths, usernames, home directories, or profile locations when a Nix value can derive them.
- When a path depends on a package or system context, derive it from Nix instead of spelling it literally. Example: prefer `${pkgs.tmux}/bin/tmux` or `${config.home.homeDirectory}` over hardcoded paths like `/etc/profiles/per-user/chant/bin/tmux` or `/Users/chant/...`.

## Repo Shape

- `flake.nix` and `flake.lock`: flake entrypoint and pinned inputs.
- `nix/hosts/darwin/nyx/default.nix`: host-specific darwin configuration.
- `nix/home/chant/default.nix`: Home Manager user configuration.
- `nix/modules/shared/*.nix`: shared tool and package modules.
- `nix/modules/darwin/defaults.nix`: darwin-specific defaults.

## Change Approach

- Make focused edits that match the existing module layout.
- Prefer adding or updating the relevant shared or host module over introducing ad hoc files.
- If a tool is not configured yet and the `v1` branch may be useful as reference, pause and ask first.
