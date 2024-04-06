#!/bin/zsh

__flutter=true
__android=true
__clang=true

__path=""

# asdf
. "$(brew --prefix asdf)/libexec/asdf.sh"

# flutter
if $__flutter; then
  export PUB_CACHE="$HOME/.pub-cache"
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
  export CPATH="/usr/local/include:/opt/homebrew/include:/opt/homebrew/opt/llvm/include:$CPATH"
  alias cmbs='cmake -B build -S . -DCMAKE_EXPORT_COMPILE_COMMANDS=ON'
  alias cmbb='cmake --build build'
  alias cmbt='cmake --build build --target'
  alias ctb='ctest --test-dir build --output-on-failure'
fi

# append local path to PATH
export PATH="$__path:$PATH"

