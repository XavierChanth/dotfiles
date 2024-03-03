#!/bin/zsh

# flutter
export PUB_CACHE="$HOME/.pub-cache"
export FLUTTER_ROOT="$HOME/dev/flutter"
export PATH="$PUB_CACHE/bin:$FLUTTER_ROOT/bin:$PATH"
alias pub='dart pub'
alias melos='dart run melos'

# android
export ANDROID_HOME="/Users/chant/Library/Android/sdk"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"

# node
 export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# rust
export PATH="$HOME/.cargo/bin:$PATH"

# clang
export CPATH="/usr/local/include:/opt/homebrew/include:/opt/homebrew/opt/llvm/include:$CPATH"
alias cmbs='cmake -B build -S . -DCMAKE_EXPORT_COMPILE_COMMANDS=ON'
alias cmbb='cmake --build build'
alias cmbt='cmake --build build --target'
alias ctb='ctest --test-dir build --output-on-failure'

# java
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

