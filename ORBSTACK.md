# Orbstack Setup

This guide links orbstack machines to the macos home to give a near seamless
experience (only works if your dotfiles are portable).

Note that this doesn't actually move the HOME directory on the Linux machine,
but rather only moves HOME in the shell session. Some applications which depend
on daemons and background jobs will not work properly as a result. I prefer
this approach to avoid applications in the VM that are outside of my control
from modifying my macos home directory. For this reason, alone I don't recommend
using `usermod` to actually move the Linux home directory to your macos home
directory.

## Account Setup

Set your username for your user account:

```sh
sudo -s
```

Change 'chant' to your username:

```sh
passwd chant
```

## Brew / zsh setup

I prefer using brew as my package manager so that my dotfiles scripts remain
portable and minimal. If you don't want to install brew, then skip that step
and install zsh through the system package manager (and change zsh paths
accordingly).

Install git on your orbstack machine (assumes your package manager is apt):

```sh
apt install git
```

Install brew from `https://brew.sh`:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Install zsh through brew:

```sh
/home/linuxbrew/.linuxbrew/bin/brew install zsh
```

Edit the `/home/$USER/.zshrc` file:

```sh
#!/bin/bash

export HOME="/Users/$USER"
source /Users/$USER/.zshrc
```

Then logout and login to the orb machine.

Now, whenever you log in to the orb machine, your default shell will be zsh,
with your macos home directory as the $HOME environment variable.

Note that this only works if your dotfiles are portable across macos & linux like
mine are.

## Something didn't work, how do I go back?

Change your shell back to bash (one of the benefits of doing this in zsh instead
of the default shell).

```sh
chsh -s /bin/bash
```

Then logout and login to the orb machine.
