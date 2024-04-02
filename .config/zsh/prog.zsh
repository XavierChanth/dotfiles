#!/bin/zsh

__flutter=true
__android=true
__node=false
__bun=true
__rust=false
__clang=true
__java=true
__conda=true
__zsh_hl=true

# To avoid expanding $__path lots of times
__path=""

# flutter
if $__flutter; then
  export PUB_CACHE="$HOME/.pub-cache"
  export FLUTTER_ROOT="$HOME/dev/flutter"
  __path="$PUB_CACHE/bin:$FLUTTER_ROOT/bin:$__path"
  # dart completions
  [[ -f $XDG_CONFIG_HOME/.dart-cli-completion/zsh-config.zsh ]] && . $XDG_CONFIG_HOME/.dart-cli-completion/zsh-config.zsh || true
  alias pub='dart pub'
  alias melos='dart run melos'
fi

# android
if $__android; then
  export ANDROID_HOME="/Users/chant/Library/Android/sdk"
  __path="$ANDROID_HOME/cmdline-tools/latest/bin:$__path"
fi

# node
if $__node; then
  export NVM_DIR="$HOME/.nvm"
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
    [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
fi

# bun
if $__bun; then
  export BUN_INSTALL="$HOME/.bun"
  __path="$BUN_INSTALL/bin:$__path"
# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
fi

# rust
if $__rust; then
  $HOME/.cargo/env
  __path="$HOME/.cargo/bin:$__path"
fi

# clang
if $__clang; then
  export CPATH="/usr/local/include:/opt/homebrew/include:/opt/homebrew/opt/llvm/include:$CPATH"
  alias cmbs='cmake -B build -S . -DCMAKE_EXPORT_COMPILE_COMMANDS=ON'
  alias cmbb='cmake --build build'
  alias cmbt='cmake --build build --target'
  alias ctb='ctest --test-dir build --output-on-failure'
fi

# java
if $__java; then
  export JAVA_HOME="/opt/homebrew/opt/openjdk"
  __path="/opt/homebrew/opt/openjdk/bin:$__path"
fi

if $__conda; then
  __conda_setup="$('/opt/homebrew/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
      eval "$__conda_setup"
  else
      if [ -f "/opt/homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
          . "/opt/homebrew/anaconda3/etc/profile.d/conda.sh"
      else
          export __path="/opt/homebrew/anaconda3/bin:$__path"
      fi
  fi
  unset __conda_setup
fi

# syntax highlighting must be done last for it to work correctly
if $__zsh_hl && command -v brew &>/dev/null; then
  [[ -f $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# append local path to PATH
export PATH="$__path:$PATH"

