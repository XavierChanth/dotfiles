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

- `flake.nix` and `flake.lock`: thin flake entrypoint and pinned inputs.
- `nix/default.nix` and `nix/inventory.nix`: flake outputs and canonical host inventory.
- `nix/hosts/{darwin,nixos}/*`: host-specific system configuration.
- `nix/home/chant/default.nix`: Home Manager user configuration.
- `nix/modules/{shared,home,darwin,nixos}/*`: reusable platform and user modules.
- `scripts/*.sh`: repository-local maintenance and lab deployment entrypoints.
- `bin/shared` and `bin/hosts/*`: commands intended for the configured user PATH.
- `docs/lab/*`: lab architecture and operational runbooks.
- `tests/*`: repository script regression tests.

## Change Approach

- Make focused edits that match the existing module layout.
- Prefer adding or updating the relevant shared or host module over introducing ad hoc files.
- If a tool is not configured yet and the `v1` branch may be useful as reference, pause and ask first.
