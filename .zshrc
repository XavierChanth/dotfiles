#!/bin/zsh

set keyseq-timeout 0

export XDG_CONFIG_HOME="$HOME/.config"
export PATH="$HOME/.local/bin:/opt/homebrew/bin:$PATH"
export LANG="en_CA.UTF-8"
export TMUX_CONF="$XDG_CONFIG_HOME/tmux/tmux.conf"

export EDITOR="nvim"
export VISUAL="nvim"

source $XDG_CONFIG_HOME/zsh/secrets.zsh
source $XDG_CONFIG_HOME/zsh/alias.zsh
source $XDG_CONFIG_HOME/zsh/atsign.zsh
source $XDG_CONFIG_HOME/zsh/brew.zsh
source $XDG_CONFIG_HOME/zsh/commands.zsh
source $XDG_CONFIG_HOME/zsh/git.zsh
source $XDG_CONFIG_HOME/zsh/iterm2.zsh
source $XDG_CONFIG_HOME/zsh/prog.zsh

# Below here is the stuff automatically added by install scripts

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

# dart completions
[[ -f /Users/chant/.dart-cli-completion/zsh-config.zsh ]] && . /Users/chant/.dart-cli-completion/zsh-config.zsh || true

# bun completions
[ -s "/Users/chant/.bun/_bun" ] && source "/Users/chant/.bun/_bun"


# syntax highlighting must be done last for it to work correctly
if command -v brew &>/dev/null; then
  [[ -f $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
