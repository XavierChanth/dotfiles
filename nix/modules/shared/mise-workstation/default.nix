{ name="mise-workstation"; platforms=["darwin" "nixos"]; home=[./home.nix]; stow=[{name="mise";order=100;target=".config/mise";prepare=[".config/mise"]; }]; }
