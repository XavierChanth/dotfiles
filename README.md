# dotfiles

This branch is the `v2` rewrite of the dotfiles repository. It keeps the setup
in the same repo as `v1`, but reorganizes the system around a Nix flake with
`nix-darwin`, Home Manager, and a small Stow layer for tool configs that still
fit best as tracked dotfiles.

## Layout

- `flake.nix`: top-level flake entrypoint and inputs.
- `hosts/darwin/nyx`: host-specific nix-darwin configuration.
- `home/chant`: Home Manager user configuration.
- `modules/shared`: shared modules for packages and shell tooling.
- `modules/darwin`: macOS-specific modules such as defaults, Homebrew, and
  input tooling.
- `stow`: application configs that are linked into place during Home Manager
  activation.
- `bin`: shared and host-specific helper scripts.

## What This Config Manages

- System configuration with `nix-darwin`
- User environment with Home Manager
- Homebrew taps and casks through Nix-managed Homebrew integration
- Tool configs for Git, Zsh, tmux, Neovim, Zed, Ghostty, JJ, and Kanata

## Apply The Configuration

On the `nyx` host, build and switch the darwin configuration with:

```bash
darwin-rebuild switch --flake .#nyx
```

The host config also expects Rosetta to be installed on Apple Silicon before or
alongside the first switch:

```bash
softwareupdate --install-rosetta --agree-to-license
```

If you only want to evaluate the Home Manager profile, this flake also exposes:

```bash
home-manager switch --flake .#chant@nyx
```

## Notes

This repo is the source of truth for the new migration work. The `v1` branch is
still useful as historical reference, but changes for the new setup should land
here unless there is a specific reason to backport them.
