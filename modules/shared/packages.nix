{
  lib,
  pkgs,
  inputs,
  system,
  ...
}: {
  home.packages =
    (with pkgs; [
      # Shell
      bash
      zsh
      spaceship-prompt

      # Core Utilities
      coreutils
      moreutils
      fastfetch
      curl
      vim
      parallel
      stow
      tmux
      tree
      unar
      unzip
      wget

      # Networking tools
      bind
      iperf3
      lsof
      nettools
      nmap
      openssl

      # Pagers
      less
      bat
      bat-extras.batdiff
      bat-extras.batgrep
      bat-extras.batman
      bat-extras.batpipe
      bat-extras.batwatch
      bat-extras.prettybat

      # Development
      neovim
      tree-sitter
      fd
      fzf
      ripgrep
      just
      jq

      # Fonts
      nerd-fonts.commit-mono
      nerd-fonts.jetbrains-mono

      # Git
      git
      difftastic
      jujutsu

      # File-format based Utilities
      imagemagick
      pandoc
      poppler
      resvg

      # CLI Apps
      flyctl
      gh
      yazi

      # Programming Languages
      basedpyright
      bun
      cmake
      docker-compose
      docker-compose-language-service
      dockerfile-language-server
      go
      gofumpt
      gopls
      hadolint
      lua-language-server
      neocmakelsp
      ninja
      nodejs
      pnpm
      prettier
      python3
      ruby
      ruff
      cargo
      cue
      rust-analyzer
      rustc
      shellcheck
      shfmt
      stylua
      svelte-language-server
      tailwindcss-language-server
      tinymist
      tombi
      typst
      uv
      vscode-json-languageserver
      vtsls
      yaml-language-server
      zig
      zls
    ])
    ++ lib.optionals pkgs.stdenv.isDarwin (with pkgs; [
      # Mac only
      iproute2mac
    ])
    ++ lib.optionals (!pkgs.stdenv.isDarwin) (with pkgs; [
      # Keyboard
      kanata

      # Linux
      traceroute
      iproute2
    ]);
}
