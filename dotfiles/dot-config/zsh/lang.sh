#!/bin/zsh

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

__path=""

if command_exists vfox; then
  alias vfox='if [ -z $__VFOX_SHELL ]; then eval "$(\vfox activate zsh)"; fi; vfox'
fi

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
alias cmbs='cmake -B build -S . -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_COMPILER=gcc -DCMAKE_C_FLAGS="-Wno-error"'
alias cmbb='cmake --build build'
alias cmbt='cmake --build build --target'
alias cmcc='ln -s build/compile_commands.json .'
alias ctb='ctest --test-dir build --output-on-failure'

# golang
if command_exists go; then
  __path="$HOME/go/bin:$__path"
fi

# rust / cargo
if command_exists cargo; then
  __path="$HOME/.cargo/bin:$__path"
fi

# dotnet
if command_exists dotnet; then
  __path="$HOME/.dotnet/tools:$__path"
fi

# append local path to PATH
export PATH="$__path:$PATH"
