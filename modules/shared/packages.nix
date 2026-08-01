{
  config,
  lib,
  pkgs,
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
    toolchain="1.97.0"

    toolchains="$(${pkgs.rustup}/bin/rustup toolchain list 2>/dev/null || true)"
    if ! printf '%s\n' "$toolchains" | ${pkgs.gnugrep}/bin/grep -Eq '^1\.97\.0(-[^[:space:]]+)?([[:space:]]|$)'; then
      ${pkgs.rustup}/bin/rustup toolchain install "$toolchain" --profile minimal
    fi

    rust_host="$(${pkgs.rustup}/bin/rustup run "$toolchain" rustc -vV | ${pkgs.gawk}/bin/awk '/^host: / { print $2 }')"
    installed="$(${pkgs.rustup}/bin/rustup component list --toolchain "$toolchain" --installed)"
    missing_components=""
    for component in cargo clippy rustc rust-analyzer rustfmt; do
      if ! printf '%s\n' "$installed" | ${pkgs.gnugrep}/bin/grep -q "^$component-$rust_host$"; then
        missing_components="$missing_components $component"
      fi
    done
    if [ -n "$missing_components" ]; then
      # shellcheck disable=SC2086
      ${pkgs.rustup}/bin/rustup component add --toolchain "$toolchain" $missing_components
    fi

    if ! printf '%s\n' "$installed" | ${pkgs.gnugrep}/bin/grep -q '^rust-std-wasm32-unknown-unknown$'; then
      ${pkgs.rustup}/bin/rustup target add --toolchain "$toolchain" wasm32-unknown-unknown
    fi

    # rustup annotates the selected line with either `(default)` or
    # `(active, default)`, depending on whether a directory override is active.
    if ! printf '%s\n' "$toolchains" | ${pkgs.gnugrep}/bin/grep -E '^1\.97\.0(-[^[:space:]]+)?[[:space:]].*\(.*default.*\)$' >/dev/null; then
      ${pkgs.rustup}/bin/rustup default "$toolchain"
    fi

    rust_sysroot="$(${pkgs.rustup}/bin/rustup run "$toolchain" rustc --print sysroot)"
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
      docker-compose-language-service
      dockerfile-language-server
      go
      gofumpt
      mise
      gopls
      hadolint
      lua-language-server
      neocmakelsp
      ninja
      nodejs
      pnpm
      prettier
      postgresql_16
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
      # Linux
      traceroute
      iproute2
    ]);
}
