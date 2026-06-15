{
  config,
  hostProfile,
  inputs,
  lib,
  username,
  ...
}: let
  userHome = config.users.users.${username}.home;

  managedTaps = {
    "homebrew/homebrew-core" = inputs.homebrew-core;
    "homebrew/homebrew-cask" = inputs.homebrew-cask;
    "rwx-cloud/homebrew-tap" = inputs.homebrew-rwx;
  };

  brewTaps = [
    "homebrew/homebrew-cask"
    "homebrew/homebrew-core"
    "rwx-cloud/tap"
  ];

  trustedThirdPartyTaps = [
    "rwx-cloud/tap"
  ];

  trustedThirdPartyTapArgs = lib.escapeShellArgs trustedThirdPartyTaps;

  baseCasks = [
    "claude"
    "codex-app"
    "cursor"
    "docker-desktop"
    "ghostty"
    "google-chrome"
    "helium-browser"
    "keepassxc"
    "obsidian"
    "raycast"
    "t3-code"
    "tailscale-app"
    "vlc"
    "zed"
  ];

  localOnlyCasks = [
    "discord"
    "hiddenbar"
    "hyperkey"
    "macshot"
    "microsoft-office"
    "microsoft-teams"
    "readdle-spark"
    "spotify"
    "steam"
    "windows-app"
    "zoom"
  ];
in {
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = username;
    autoMigrate = true;
    taps = managedTaps;
    mutableTaps = false;
  };

  homebrew = {
    enable = true;
    # Keep Brew Bundle from trying to mutate the immutable Taps dir.
    taps = brewTaps;
    caskArgs.appdir = "/Applications";
    onActivation = {
      autoUpdate = false;
      cleanup = "uninstall";
      upgrade = false;
    };
    brews = [
      "rwx"
    ];
    casks = baseCasks ++ (if hostProfile.isRemote then [] else localOnlyCasks);
  };

  system.activationScripts.homebrew.text = lib.mkOrder 750 ''
    # Homebrew tap trust is user-scoped. nix-darwin invokes brew bundle with
    # sudo --set-home, which may not see trust created from an interactive shell.
    echo >&2 "Trusting Homebrew taps..."
    if [ -f "${config.homebrew.prefix}/bin/brew" ]; then
      PATH="${config.homebrew.prefix}/bin:$PATH" \
      sudo \
        --preserve-env=PATH \
        --user=${lib.escapeShellArg username} \
        --set-home \
        env \
        "${config.homebrew.prefix}/bin/brew" trust --tap ${trustedThirdPartyTapArgs}

      PATH="${config.homebrew.prefix}/bin:$PATH" \
      sudo \
        --preserve-env=PATH \
        --user=${lib.escapeShellArg username} \
        --set-home \
        env \
        XDG_CONFIG_HOME="${userHome}/.config" \
        "${config.homebrew.prefix}/bin/brew" trust --tap ${trustedThirdPartyTapArgs}
    fi
  '';
}
