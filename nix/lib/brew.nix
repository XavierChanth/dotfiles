{ config, inputs, lib, resolvedGroups, username, ... }: let
  brew = resolvedGroups.brew;
  hasRwx = builtins.elem "rwx-cloud/tap" brew.taps;
  managedTaps = { "homebrew/homebrew-core" = inputs.homebrew-core; "homebrew/homebrew-cask" = inputs.homebrew-cask; } // lib.optionalAttrs hasRwx { "rwx-cloud/homebrew-tap" = inputs.homebrew-rwx; };
  trusted = lib.optionals hasRwx [ "rwx-cloud/tap" ];
  trustArgs = lib.escapeShellArgs trusted;
  userHome = config.users.users.${username}.home;
in {
  imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];
  nix-homebrew = { enable = true; enableRosetta = lib.mkDefault false; user = username; autoMigrate = true; taps = managedTaps; mutableTaps = false; };
  homebrew = { enable = true; taps = brew.taps; caskArgs.appdir = "/Applications"; onActivation = { autoUpdate = false; cleanup = "uninstall"; upgrade = true; }; inherit (brew) brews casks; };
  system.activationScripts = lib.mkIf (trusted != []) { homebrew.text = lib.mkOrder 750 ''
    echo >&2 "Trusting Homebrew taps..."
    if [ -f "${config.homebrew.prefix}/bin/brew" ]; then
      PATH="${config.homebrew.prefix}/bin:$PATH" sudo --preserve-env=PATH --user=${lib.escapeShellArg username} --set-home env "${config.homebrew.prefix}/bin/brew" trust --tap ${trustArgs}
      PATH="${config.homebrew.prefix}/bin:$PATH" sudo --preserve-env=PATH --user=${lib.escapeShellArg username} --set-home env XDG_CONFIG_HOME="${userHome}/.config" "${config.homebrew.prefix}/bin/brew" trust --tap ${trustArgs}
    fi
  ''; };
}
