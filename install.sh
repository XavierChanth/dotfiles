#!/bin/bash

# Make files and directories used but not "owned" by dotfiles
touch "$HOME"/.zshenv

mkdir -p "$HOME/dev"
mkdir -p "$HOME/src"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/asdf"

# ensure git is installed
if command -v "git" >/dev/null; then
  echo "git not found, install git before continuing..."
  echo "how did you even git this onto your machine?"
  exit 1
fi

if ! command -v stow &>/dev/null; then
  echo "stow not found, install gnu stow before continuing..."
  exit 2
fi

# git global settings
# I don't like to stow my .gitconfig directly
# If a job ever requires multiple git profiles:
#   - I may want/need to keep it private
#   - I may only want the extra work config on the work system
git config --global user.name xavierchanth
git config --global user.email xchanthavong@gmail.com
git config --global user.signingkey $HOME/.ssh/id_ed25519.pub
git config --global filter.lfs.clean 'git-lfs clean -- %f'
git config --global filter.lfs.smudge 'git-lfs smudge -- %f'
git config --global filter.lfs.process 'git-lfs filter-process'
git config --global filter.lfs.required true
git config --global commit.gpgsign true
git config --global gpg.format ssh
git config --global alias.wt worktree
git config --global pull.ff only

# install brew
if [ "$(uname)" = 'Darwin' ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  /opt/homebrew/bin/brew install stow
  stow -d "$SCRIPT_DIRECTORY/Library" -t "$HOME/Library" .
  defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "$HOME/.xavierchanth/iterm2"
  defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
fi

# install asdf
asdf_path="$HOME/.local/asdf"
git clone https://github.com/asdf-vm/asdf.git "$asdf_path" --branch v0.14.0

asdf_install() {
  if [ -z "$2" ]; then
    2='latest'
  fi
  "$asdf_path/bin/asdf" plugin add "$1"
  "$asdf_path/bin/asdf" install "$1" "$2"
  "$asdf_path/bin/asdf" local "$1" "$2"
}

asdf_install fzf
asdf_install ripgrep
asdf_install tmux
asdf_install delta
asdf_install lazygit
asdf_install neovim stable

# install spaceship
git clone --depth=1 https://github.com/spaceship-prompt/spaceship-prompt.git "$HOME/.config/spaceship-prompt"

# sync dotfiles
stow -d "$SCRIPT_DIRECTORY" -t "$HOME" .

# additional programming languages worth installing
asdf_install flutter
asdf_install golang
asdf_install jq
asdf_install python
asdf_install uv
asdf_install cmake

# sync nvim
RUN nvim --headless "+Lazy! sync" +qa

"$SCRIPT_DIRECTORY"/check-env.sh
