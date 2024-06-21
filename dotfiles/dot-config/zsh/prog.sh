#!/bin/bash

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

__path=""

# flutter
export FLUTTER_ROOT="$HOME/.local/dev/flutter"
if [ -d $FLUTTER_ROOT ]; then
  export PUB_CACHE="$HOME/.pub-cache"
  __path="$PUB_CACHE/bin:$FLUTTER_ROOT/bin:$__path"
  # dart completions
  [[ -f $XDG_CONFIG_HOME/.dart-cli-completion/zsh-config.zsh ]] && . $XDG_CONFIG_HOME/.dart-cli-completion/zsh-config.zsh || true
  alias pub='dart pub'
  alias melos='dart run melos'
fi

# android
export ANDROID_HOME="/Users/chant/Library/Android/sdk"
__path="$ANDROID_HOME/cmdline-tools/latest/bin:$__path"

# clang
if [ "$(uname)" = 'Darwin' ]; then
  export CPATH="/usr/local/include:/opt/homebrew/include:/opt/homebrew/opt/llvm/include:$CPATH"
else
  export CPATH="/usr/local/include:$CPATH"
fi

# cmake
alias cmbs='cmake -B build -S . -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_COMPILER=gcc -DCMAKE_C_FLAGS="-Wall -Wextra -Wpedantic -Wno-error -Wno-calloc-transposed-args -Werror-implicit-function-declaration"'
alias cmbb='cmake --build build'
alias cmbt='cmake --build build --target'
alias cmcc='ln -s build/compile_commands.json .'
alias ctb='ctest --test-dir build --output-on-failure'

#golang
if command_exists go; then
  __path="$HOME/go/bin:$__path"
fi

# nvm
# wrap this in a function because it is slow and we don't want to run this unless we need node
init_nvm() {
  export NVM_DIR="$HOME/.local/dev/nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
}

# append local path to PATH
export PATH="$__path:$PATH"
