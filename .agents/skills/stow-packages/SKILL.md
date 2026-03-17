---
name: stow-packages
description: Use when adding or reorganizing GNU Stow-managed dotfiles in this repo. Covers the local package layout conventions, when to use dot-config plus --dotfiles, and how Home Manager activation should target each package.
---

# Stow Packages

Use this skill when working on the `stow/` tree in this dotfiles repo.

## Conventions

- The source of truth for manually managed dotfiles lives under `stow/`.
- Prefer one package per tool.
- Package contents should match the target directory shape.
- Do not introduce duplicate inner folders like `stow/nvim/nvim` or `stow/tmux/tmux`.

## Package Shapes

Use plain package contents for tools that are stowed directly into a config directory:

- `stow/jj/config.toml` -> target `~/.config/jj`
- `stow/tmux/tmux.conf` -> target `~/.config/tmux`
- `stow/nvim/init.lua` -> target `~/.config/nvim`

Use Stow dotfile mode for mixed home + XDG packages:

- `stow/git/dot-gitconfig`
- `stow/git/dot-config/...`
- `stow/zsh/dot-zshrc`
- `stow/zsh/dot-config/zsh/...`

These packages must be stowed with `--dotfiles` and `--target="$HOME"`.

## Home Manager Integration

When updating Home Manager activation:

- Use `stow --dotfiles --target="$HOME"` for mixed packages like `git` and `zsh`.
- Use per-package targets for pure XDG packages.
- Current pattern:

```sh
stow --dir="$STOW_DIR" --dotfiles --target="$HOME" --restow git zsh
stow --dir="$STOW_DIR" --target="$HOME/.config/jj" --restow jj
stow --dir="$STOW_DIR" --target="$HOME/.config/tmux" --restow tmux
stow --dir="$STOW_DIR" --target="$HOME/.config/nvim" --restow nvim
```

## Editing Rules

- Keep the package names stable unless there is a good reason to rename them.
- If a tool has both a home-level file and XDG config, prefer the `dot-*` layout instead of splitting it into multiple packages.
- If a tool is purely XDG, keep the files at the package root and point Stow at the final config directory.
