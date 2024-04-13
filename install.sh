#!/bin/sh

# .zshenv file
_home_zshenv=$([ -f "$HOME"/.zshenv ])
_home_zshenv_link=$([ -L "$HOME"/.zshenv ])
_dot_zshenv=$([ -f "$SCRIPT_DIRECTORY"/.zshenv ])
if ! $_home_zshenv_link; then
  if $_home_zshenv; then
    cp "$HOME"/.zshenv "$HOME"/.zshenv.bak
    echo "Made a backup of ~/.zshenv at $HOME/.zshenv.bak"
    if ! $_dot_zshenv; then
      mv "$HOME"/.zshenv "$SCRIPT_DIRECTORY"/.zshenv
      echo "Moving existing ~/.zshenv from the home directory into the dotfiles repo"
    else
      echo "Found a .zshenv file in both the home directory and dotfiles repo"
      echo "Using the .zshenv file in the dotfiles repo"
      echo "Please manually migrate any config from the .zshenv file in the home directory"
    fi
  else
    echo "No .zshenv file found in the home directory or dotfiles repo"
    echo "Creating a new .zshenv file in the dotfiles repo"
    touch "$SCRIPT_DIRECTORY"/.zshenv
  fi
fi

unset _home_zshenv _home_zshenv_link _dot_zshenv

# install brew
if [ "$(uname)" = 'Darwin' ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# install asdf
git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf" --branch v0.14.0

# install spaceship
git clone --depth=1 https://github.com/spaceship-prompt/spaceship-prompt.git "$HOME/.config/spaceship-prompt"

# Make folders and directories used but not "owned" by dotfiles
if ! [ -d "$HOME/dev" ]; then
  mkdir -p "$HOME/dev"
fi

if ! [ -d "$HOME/src" ]; then
  mkdir -p "$HOME/src"
fi
