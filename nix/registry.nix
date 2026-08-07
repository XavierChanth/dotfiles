# Explicit group registry. Descriptors are plain data; module evaluation happens later.
{
  editor-core = {
    name = "editor-core"; platforms = [ "darwin" "nixos" ];
    home = [ ./modules/shared/git.nix ./modules/shared/identities.nix ];
    stow = [
      { name = "jj"; order = 30; target = ".config/jj"; prepare = [ ".config/jj" ]; }
      { name = "nvim"; order = 70; target = ".config/nvim"; prepare = [ ".config/nvim" ]; }
    ];
  };
  terminal-core = {
    name = "terminal-core"; platforms = [ "darwin" "nixos" ];
    home = [ ./modules/shared/shell.nix ./modules/shared/tmux.nix ];
    stow = [
      { name = "zsh"; order = 50; target = ".config/zsh"; prepare = [ ".config/zsh" ]; }
      { name = "tmux"; order = 60; target = ".config/tmux"; prepare = [ ".config/tmux" ]; }
    ];
  };
  ssh = { name = "ssh"; platforms = [ "darwin" "nixos" ]; home = [ ./modules/shared/ssh.nix ]; };
  ai-applications = {
    name = "ai-applications"; platforms = [ "darwin" "nixos" ];
    # Implementations remain imported by the existing workstation module.
    stow = [
      { name = "agents"; order = 10; target = ".agents"; prepare = [ ".agents" ]; }
      { name = "codex"; order = 20; target = ".codex"; prepare = [ ".codex/rules" ]; }
      { name = "grok"; order = 40; target = ".grok"; prepare = [ ".grok" ]; }
      { name = "opencode"; order = 80; target = ".config/opencode"; prepare = [ ".config/opencode" ]; }
    ];
  };
  ghostty = { name = "ghostty"; platforms = [ "darwin" "nixos" ]; stow = [ { name = "ghostty-themes"; target = ".config/ghostty/themes"; prepare = [ ".config/ghostty/themes" ]; special = true; } ]; };
  mise-workstation = { name = "mise-workstation"; platforms = [ "darwin" "nixos" ]; stow = [ { name = "mise"; order = 100; target = ".config/mise"; prepare = [ ".config/mise" ]; } ]; };
  workstation-packages = {
    name = "workstation-packages"; platforms = [ "darwin" "nixos" ];
    home = [ ./modules/home/workstation.nix ];
    stow = [
      { name = "cmux"; order = 90; target = ".config/cmux"; prepare = [ ".config/cmux" ]; }
      { name = "zed"; order = 110; target = ".config/zed"; prepare = [ ".config/zed" ]; }
    ];
  };
  server-packages = { name = "server-packages"; platforms = [ "darwin" "nixos" ]; home = [ ./modules/home/server.nix ]; };
}
