# general
source "$HOME"/.config/zsh/secrets.sh

alias la='ls -a'
alias ll='la -l'
alias vim='nvim'

alias rose='arch -x86_64'
alias act='act --container-architecture linux/amd64'

alias ss='source $HOME/.zshrc'

export PATH="$HOME/.local/bin:$PATH"

# git
git config --global user.name xavierchanth
git config --global user.email xchanthavong@gmail.com

# antigen
ANTIGEN_MUTEX=false
source $HOME/.config/zsh/antigen.zsh
antigen init $HOME/.config/zsh/.antigenrc

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


# Additional commands
source $HOME/.config/zsh/commands.sh

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

