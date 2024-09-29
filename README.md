# Dotfiles

## How to install

User setup:

- Create user
- Give user sudo permissions
- Set user password
- Login as user

Dotfiles setup:

- Put ssh keys in place
- Install git
- Install GNU stow
- Clone this repo to ~/.dotfiles
- `~/.dotfiles/install`

Everything should be installed now, making the dotfiles script available on
path.

To install additional desktop packages:

`dotfiles install-desktop`

To install Zen browser config (guided installer with steps that must be done
manually):

`dotfiles install-zen-browser`
