{ pkgs }:
with pkgs;
[
  # Core
  zsh
  zsh-syntax-highlighting
  zsh-completions
  bash
  less
  coreutils
  moreutils
  vim

  # Essentials
  tmux
  bob
  tree-sitter
  ripgrep
  fzf
  git
  git-delta
  difftastic
  jujutsu
  jjui
  bat
  bat-extras
  stow
  gh
  jq
  just
  parallel
  fd
  yazi
  poppler
  imagemagick
  resvg
  unzip
  tree
  unar
  fastfetch
  pandoc

  # Networking tools
  openssl
  wget
  iperf3
  nmap
  traceroute

  # Programming languages and tools
  vscode-langservers-extracted
  yaml-language-server
  tombi
  go
  gopls
  gofumpt
  uv
  python3
  basedpyright
  ruff
  typst
  tinymist
  llvm
  gcc
  clang
  cmake
  neocmakelsp
  python3Packages.gersemi
  ninja
  zig
  zls
  rustc
  cargo
  rust-analyzer
  ruby
  bun
  nodejs
  npm
  pnpm
  svelte-language-server
  dockerfile-language-server-nodejs
  docker-compose-language-service
  hadolint
  goimports
  lua-language-server
  stylua
  prettier
  shellcheck
  shfmt
  tailwindcss-language-server
  vtsls

  # Development dependencies
  lsof
]
