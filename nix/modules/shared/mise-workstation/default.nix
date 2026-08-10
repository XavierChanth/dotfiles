{ name="mise-workstation"; platforms=["darwin" "nixos"]; home=[./home.nix]; nixos=[./system.nix]; stow=[{name="mise";order=100;target=".config/mise";prepare=[".config/mise"]; }]; }
