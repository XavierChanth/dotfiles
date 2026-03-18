{
  lib,
  pkgs,
  inputs,
  system,
  ...
}: {
  home.packages =
    (with pkgs; [
      # Core
      bash
      coreutils
      less
      moreutils
      spaceship-prompt
      vim
      zsh

      # My Essentials
      bat
      bat-extras.batdiff
      bat-extras.batgrep
      bat-extras.batman
      bat-extras.batpipe
      bat-extras.batwatch
      bat-extras.prettybat
      codex
      curl
      delta
      difftastic
      fd
      fastfetch
      fzf
      gh
      git
      imagemagick
      inputs.neovim-nightly-overlay.packages.${system}.default
      jjui
      jq
      jujutsu
      just
      nerd-fonts.commit-mono
      nerd-fonts.jetbrains-mono
      pandoc
      parallel
      poppler
      resvg
      ripgrep
      stow
      tmux
      tree
      tree-sitter
      unar
      unzip
      wget
      yazi

      # Networking tools
      bind
      iperf3
      lsof
      nettools
      nmap
      openssl
    ])
    ++ lib.optionals pkgs.stdenv.isDarwin (with pkgs; [
      # Apps

      # Programming Languages
      basedpyright
      bun
      cmake
      docker-compose-language-service
      dockerfile-language-server
      go
      gofumpt
      gopls
      hadolint
      iproute2mac
      kanata
      lua-language-server
      neocmakelsp
      ninja
      nodejs
      pnpm
      prettier
      python3
      ruby
      ruff
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
    ++ lib.optionals (!pkgs.stdenv.isDarwin) [
      pkgs.traceroute
      pkgs.iproute2
    ];
}
