{
  config,
  inputs,
  username,
  ...
}: {
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = username;
    autoMigrate = true;
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
    };
    mutableTaps = false;
  };

  homebrew = {
    enable = true;
    taps = builtins.attrNames config.nix-homebrew.taps;
    caskArgs.appdir = "/Applications";
    onActivation = {
      autoUpdate = false;
      cleanup = "uninstall";
      upgrade = false;
    };
    casks = [
      "cursor"
      "discord"
      "ghostty"
      "google-chrome"
      "helium-browser"
      "keepassxc"
      "microsoft-office"
      "microsoft-teams"
      "obs"
      "obsidian"
      "opencode-desktop"
      "raycast"
      "spotify"
      "tailscale"
      "vlc"
      "whispering"
      "windows-app"
      "zed"
      "zoom"
    ];
  };
}
