#!/bin/bash
script_dir="$(dirname -- "$(readlink -f -- "$0")")"

# Make files and directories used but not "owned" by dotfiles
touch "$HOME"/.zshenv

mkdir -p "$HOME/dev"
mkdir -p "$HOME/src"
mkdir -p "$HOME/.ssh"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/asdf"
mkdir -p "$HOME/.config"

# Prevent stow from adopting certain folders, and instead only link the files
touch "$HOME/.ssh/.stowkeep"
touch "$HOME/.local/.stowkeep"
touch "$HOME/.local/bin/.stowkeep"
touch "$HOME/.config/.stowkeep"

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# ensure git is installed
if ! command_exists git; then
  echo "git not found, install git before continuing..."
  echo "how did you even git this onto your machine?"
  exit 1
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
case "$(uname)" in
  Darwin)
    if ! command_exists brew; then
      echo "brew not found, installing it for you..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # desktop stuff
    brew install --cask aerospace raycast
    brew install felixkratz/formulae/borders bitwarden-cli

    # shell essentials
    brew install bash
    # core tools
    brew install coreutils moreutils
    # net tools
    brew install openssl wget
    # dev tools
    brew install alacritty tmux neovim ripgrep fzf git-delta stow
    # extra tools
    brew install jq uv vfox

    # alacritty font patch - super blurry without this
    defaults -currentHost write -g AppleFontSmoothing -int 0
    ;;
  Linux)
    if command_exists dnf; then
      echo "dnf package manager found, installing packages for dnf"
      # shell essentials
      sudo dnf install -y bash zsh man git sudo passwd procps
      # core tools
      sudo dnf install -y coreutils moreutils clang parallel
      # net tools
      sudo dnf install -y openssl curl wget iproute traceroute
      # dev tools
      sudo dnf install -y alacritty tmux neovim ripgrep fzf git-delta stow
      # extra tools
      sudo dnf install -y jq clang-tools-extra inotify-tools
    else
      echo "package manager not configured, configure and try again"
      exit 0
    fi

    # install uv
    if ! command_exists uv; then
      curl -fsSL https://astral.sh/uv/install.sh | sh
    fi

    # install vfox
    if ! command_exists vfox; then
      # Install vfox in a sub-shell & temp folder
      tmp_dir_name=tmp-vfox-install
      mkdir $tmp_dir_name
      (
        cd $tmp_dir_name
        curl -sSL https://raw.githubusercontent.com/xavierchanth/vfox/main/install.sh | bash
      )
      rm -rf $tmp_dir_name
    fi

    # End of linux block
    ;;
esac

if ! command_exists stow; then
  echo "stow not found, install gnu stow before continuing..."
  exit 2
fi

# install spaceship
git clone --depth=1 https://github.com/spaceship-prompt/spaceship-prompt.git "$HOME/.config/spaceship-prompt"

# sync dotfiles
stow -d "$script_dir" -t "$HOME" .

# sync nvim
nvim --headless "+Lazy! sync" +qa

# Setup vfox & programming languages
eval "$(vfox activate bash)" # bash is safer for this script, since zsh is compatible with it anyway
vfox_install() {
  vfox add "$1"
  vfox install "$1@$2"
  vfox use -g "$1@$2"
  return $?
}

# Some programming languages that I commonly use
vfox_install flutter 3.19.6
vfox_install golang 1.22.2
vfox_install nodejs 21.7.3

if ! vfox_install cmake 3.29.2; then
  command_exists dnf && sudo dnf install -y cmake
fi

if ! vfox_install python 3.12.3; then
  command_exists dnf && sudo dnf install -y python3
fi

# install lazygit directly from source
if ! command_exists lazygit; then
  eval "$(vfox activate bash)"
  go install github.com/jesseduffield/lazygit@latest
fi

# Do a healthcheck to ensure that everything I want is installed
"$script_dir"/check-env.sh
