{
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}: {
  home.file.".bunfig.toml".text = ''
    [install]
    linker = "isolated"
    globalStore = true
  '';

  home.file.".cargo/config.toml".text = ''
    [build]
    rustc-wrapper = "sccache"
    incremental = false
  '';

  home.activation.ensureRustupStable = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export CARGO_HOME="${config.home.homeDirectory}/.cargo"
    export RUSTUP_HOME="${config.home.homeDirectory}/.rustup"

    ${pkgs.rustup}/bin/rustup toolchain install stable \
      --profile minimal \
      --component cargo \
      --component clippy \
      --component rustc \
      --component rust-analyzer \
      --component rustfmt \
      --target wasm32-unknown-unknown

    ${pkgs.rustup}/bin/rustup default stable

    rust_host="$(${pkgs.rustup}/bin/rustup run stable rustc -vV | ${pkgs.gawk}/bin/awk '/^host: / { print $2 }')"
    rust_sysroot="$(${pkgs.rustup}/bin/rustup run stable rustc --print sysroot)"
    rust_lld="$rust_sysroot/lib/rustlib/$rust_host/bin/rust-lld"
    test -x "$rust_lld"
    ln -sfn "$rust_lld" "$CARGO_HOME/bin/rust-lld"
  '';

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
      # unar
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
      awscli2
      flyctl
      gh
      terraform
      yazi

      # Programming Languages
      basedpyright
      # bun
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
      cue
      rustup
      sccache
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
