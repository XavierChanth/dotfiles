{
  config,
  hostProfile,
  inputs,
  lib,
  username,
  ...
}: let
  userHome = config.users.users.${username}.home;
  isWorkstation = hostProfile.profile == "workstation";

  managedTaps = {
    "homebrew/homebrew-core" = inputs.homebrew-core;
    "homebrew/homebrew-cask" = inputs.homebrew-cask;
  } // lib.optionalAttrs isWorkstation {
    "rwx-cloud/homebrew-tap" = inputs.homebrew-rwx;
  };

  brewTaps = [
    "homebrew/homebrew-cask"
    "homebrew/homebrew-core"
  ] ++ lib.optionals isWorkstation ["rwx-cloud/tap"];

  trustedThirdPartyTaps = lib.optionals isWorkstation ["rwx-cloud/tap"];

  trustedThirdPartyTapArgs = lib.escapeShellArgs trustedThirdPartyTaps;

  workstationCasks = [
    "codex-app"
    "firefox"
    "ghostty"
    "google-chrome"
    "google-drive"
    "helium-browser"
    "keepassxc"
    "obsidian"
    "raycast"
    "tailscale-app"
    "vlc"
    "zed"
    "discord"
    "hiddenbar"
    "hyperkey"
    "macshot"
    "microsoft-excel"
    "microsoft-outlook"
    "microsoft-powerpoint"
    "microsoft-teams"
    "microsoft-word"
    "onedrive"
    "readdle-spark"
    "spotify"
    "steam"
    "t3-code"
    "windows-app"
    "zoom"
  ];

  serverCasks = [
    "tailscale-app"
  ];
in {
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  nix-homebrew = {
    enable = true;
    enableRosetta = isWorkstation;
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
      upgrade = true;
    };
    brews = lib.optionals isWorkstation [
      "cliproxyapi"
      "rwx"
    ];
    casks = if isWorkstation then workstationCasks else serverCasks;
  };

  system.activationScripts = lib.mkIf isWorkstation {
    homebrew.text = lib.mkOrder 750 ''
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
  };
}
