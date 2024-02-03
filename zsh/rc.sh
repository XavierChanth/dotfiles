#!/bin/zsh

# general
source "$HOME"/.config/zsh/secrets.sh

# you probably think this is dumb right?
# well... it actually does something really cool
# it makes it so that you can use sudo with aliases
alias sudo='sudo '

alias rose='arch -x86_64'
alias act='act --container-architecture linux/amd64'

alias ss='source $HOME/.zshrc'

export PATH="$HOME/.local/bin:$PATH"

# git
git config --global user.name xavierchanth
git config --global user.email xchanthavong@gmail.com
git config --global user.signingkey /Users/chant/.ssh/id_ed25519.pub
git config --global filter.lfs.clean 'git-lfs clean -- %f'
git config --global filter.lfs.smudge 'git-lfs smudge -- %f'
git config --global filter.lfs.process 'git-lfs filter-process'
git config --global filter.lfs.required true
git config --global commit.gpgsign true
git config --global gpg.format ssh
git config --global alias.wt worktree
alias glog='git log --oneline --decorate --graph'
alias gloga='glog --all'
clone() {
  REPO=$1
  shift;

  if [[ $REPO =~ ^(git@github\.com:.*|https:\/\/github\.com\/.*)$ ]]; then
    prefix=""
  else
    prefix="git@github.com:"
  fi

  git clone "$prefix$REPO" "$@"
}

# antigen
ANTIGEN_MUTEX=false
source $HOME/.config/zsh/antigen.zsh

antigen use oh-my-zsh
antigen bundles <<EOBUNDLES
# Load bundles from external repos
  zsh-users/zsh-completions
  zsh-users/zsh-autosuggestions
  zsh-users/zsh-syntax-highlighting
  supercrabtree/k
EOBUNDLES

# Disable annoying prompts
export SPACESHIP_CONDA_SHOW=false
export SPACESHIP_GCLOUD_SHOW=false

ANTIGEN_THEME=spaceship-prompt/spaceship-prompt
if ! antigen list | grep $ANTIGEN_THEME; then
  antigen theme $ANTIGEN_THEME
fi

antigen apply

# iterm2
if ! [ -f "$HOME"/.iterm2_shell_integration.zsh ]; then
  curl -L https://iterm2.com/shell_integration/zsh -o "$HOME"/.iterm2_shell_integration.zsh
fi

# brew
HOMEBREW_NO_ENV_HINTS=true

# flutter
export PUB_CACHE="$HOME/.pub-cache"
export FLUTTER_ROOT="$HOME/dev/flutter"
export PATH="$PUB_CACHE/bin:$FLUTTER_ROOT/bin:$PATH"

# node
 export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# android
export ANDROID_HOME="/Users/chant/Library/Android/sdk"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"

# rust
export PATH="$HOME/.cargo/bin:$PATH"


# clang
export CPATH="/usr/local/include:/opt/homebrew/include:/opt/homebrew/opt/llvm/include:$CPATH"
alias cmbs='cmake -B build -S . -DCMAKE_EXPORT_COMPILE_COMMANDS=ON'
alias cmbb='cmake --build build'
alias cmbt='cmake --build build --target'
alias ctb='ctest --test-dir build'

#tmux
t() {
  tmux a || tmux
}

#cd
alias xc='cd ~/src/xc'
alias xcdf='cd ~/src/xc/dotfiles'
alias af='cd ~/src/af'
alias afnp='cd ~/src/af/noports'
alias afc='cd ~/src/af/at_c'

# vim
alias v='nvim'
alias vi='nvim'
alias vim='nvim'

# dart/flutter
alias pub='dart pub'
alias melos='dart run melos'

# devops
alias dump_cards='with_dc_pat ~/src/ac/dump_cards/dump_cards.py'
alias vsce='with_vsce_pat vsce'

rollup() {
  if [ $# -ne 2 ] ; then
    echo "Usage rollup <BASE_PR> <LAST_PR>"
    exit 1
  fi
  BASE_PR=$1
  LAST_PR=$2
  git pull
  gh pr checkout "$BASE_PR"
  for (( i=(($BASE_PR + 1)); i<=$LAST_PR; i++ ));
  do
    IS_CLOSED=$(gh pr view "$i" --json closed -q .closed || false);
    if [ -n "$IS_CLOSED" ] && [ ! "$IS_CLOSED" ]; then
      PR_BRANCH=$(gh pr view "$i" --json headRefName -q .headRefName);
      git merge origin/"$PR_BRANCH" -m "build(deps): Rollup merge branch for #${i} ${PR_BRANCH}";
    fi
  done
  git push
}

# atsign
atDirectory() {
  head -n 1 < <(openssl s_client -connect root.atsign.org:64 -quiet -verify_quiet < <(echo "$1"; sleep 1; echo "@exit") 2>/dev/null)
}

atServer() {
  fqdn=$(atDirectory "$1" | tr -d '\r\n\t ')
  openssl s_client -connect "${fqdn:1}"
}

pkam() {
  at_pkam -p "$HOME/.atsign/keys/$1_key.atKeys" -r "$2"
}

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /Users/chant/.dart-cli-completion/zsh-config.zsh ]] && . /Users/chant/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]


test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

