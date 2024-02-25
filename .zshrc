#!/bin/zsh

# general
source "$HOME"/.config/zsh/secrets.sh

# you probably think this is dumb right?
# well... it actually does something really cool
# it makes it so that you can use sudo with other aliases
alias sudo='sudo '

alias rose='arch -x86_64'
alias act='act --container-architecture linux/amd64'

alias s='source $HOME/.zshrc'
alias q='exit'

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
alias lg='lazygit'
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
alias ctb='ctest --test-dir build --output-on-failure'

#tmux
alias t='tmux' 
# use fzf to select and kill tmux session
alias tks="tmux ls | fzf -m | awk -F':' '{print \$1}' | xargs -I{} tmux kill-session -t {}"
alias vks="tmux ls | grep '^_' | fzf -m | awk -F':' '{print \$1}' | xargs -I{} tmux kill-session -t {}"

#cd
alias ss='cd ~/src'
alias sxc='cd ~/src/xc'
alias saf='cd ~/src/af'
alias dd='cd ~/dev'
alias dnp='cd ~/dev/noports'

# vim
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
vv() {
  selected=$(find $HOME/src/af $HOME/src/ac $HOME/src/xc $HOME/src/sa -mindepth 1 -maxdepth 1 -type d | fzf)
  if [ -z "$selected" ]; then
    return
  fi
  cd $selected;
  DISABLE_AUTO_TITLE="true" echo -e "\033];nvim - $selected\007"
  nvim;
  DISABLE_AUTO_TITLE="false"
}

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
atdirectory() {
  head -n 1 < <(openssl s_client -connect root.atsign.org:64 -quiet -verify_quiet < <(echo "$1"; sleep 1; echo "@exit") 2>/dev/null)
}

atserver() {
  pkam_command="at_pkam"
  atsign="$1"
  if [[ ${atsign:0:1} != "@" ]] ; then 
    atsign="@$atsign"
  fi
  atkeys="$HOME/.atsign/keys/${atsign}_key.atKeys"
  time=$(date +%s)
  pipe="/tmp/atserver/$atsign-$time"

  mkdir -p "/tmp/atserver"
  mkfifo "$pipe"

  fqdn=$(atdirectory "${atsign:1}" | tr -d '\r\n\t ')
  if [ -f $atkeys ]; then
  # subshell to prevent the trap from leaking into the main shell
  (
    is_done=0
    _cleanup() {
      if [ $is_done -gt 0 ]; then
        return
      fi
      is_done=1
      rm "$pipe" 2>&1 >/dev/null
    }
    trap _cleanup INT TERM EXIT
    _pkam() {
      # Some sorcery to get the challenge to actually write to the openssl client
      # I think this tail flushes the pipe which is what allows us to write
      echo "from:$atsign"
      (tail -f "$pipe" &)
      tail_pid=$!
      challenge="$(head -n 1 $pipe)"
      echo "pkam:$($pkam_command -p $atkeys -r ${challenge:5})"
    }

    (_pkam && cat)  | (openssl s_client -brief -connect "${fqdn:1}") | tee "$pipe"
  )
  else
    # no atkeys file, don't try to pkam
    openssl s_client -brief -connect "${fqdn:1}" 
  fi
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


# bun completions
[ -s "/Users/chant/.bun/_bun" ] && source "/Users/chant/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
