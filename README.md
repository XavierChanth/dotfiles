# Dotfiles

## How to install

User setup:

- Create user
- Give user sudo permissions
- Set user password
- Login as user

Dotfiles setup:

- Put ssh keys in place
- Install git curl zsh
- Install
  [brew requirements](https://docs.brew.sh/Homebrew-on-Linux#requirements)
  (Linux)
- Clone this repo to ~/.dotfiles
- `~/.dotfiles/install`

Everything should be installed now, making the dotfiles script available on
path.

To install additional desktop packages:

`dotfiles install-desktop`

To install Zen browser config (guided installer with steps that must be done
manually):

`dotfiles install-zen-browser`


## Minimum Viable Windows setup (TODO)

Steps:
- Setup SSH
- Install Winget packages
- Setup Windows Terminal with Git bash as the default
  - `"C:/Program Files/Git/bin/bash.exe" -i -l`
- Setup Git bash as the default shell for ssh
- Install nvim config to $LOCALAPPDATA/nvim
- Install packages with Lazy
- Install CommitMonoNerdFont

Winget packages:

```
Git.Git
Neovim.Neovim
BurntSushi.ripgrep.MSVC
sharkdp.fd
zig.zig
jj-vcs.jj
```

Note: zig is used to build nvim-treesitter



