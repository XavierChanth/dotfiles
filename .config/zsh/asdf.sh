#!/bin/bash

export ASDF_DIR="$HOME/.asdf"
. "$ASDF_DIR/asdf.sh"
FPATH="$ASDF_DIR/completions:$FPATH"

__flutter=true
__android=true
__clang=true

__path=""

# flutter
if $__flutter && $(asdf where flutter &>/dev/null); then
  export PUB_CACHE="$HOME/.pub-cache"
  export FLUTTER_ROOT="$(asdf where flutter)"
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

# clang
if $__clang; then
  if $is_darwin; then
    export CPATH="/usr/local/include:/opt/homebrew/include:/opt/homebrew/opt/llvm/include:$CPATH"
  else
    export CPATH="/usr/local/include:$CPATH"
  fi

  alias cmbs='cmake -B build -S . -DCMAKE_EXPORT_COMPILE_COMMANDS=ON'
  alias cmbb='cmake --build build'
  alias cmbt='cmake --build build --target'
  alias ctb='ctest --test-dir build --output-on-failure'
fi

# append local path to PATH
export PATH="$__path:$PATH"
