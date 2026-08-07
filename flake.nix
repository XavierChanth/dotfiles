{
  description = "Cross-platform-ready dotfiles flake with nix-darwin and Home Manager";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nix-darwin = { url = "github:LnL7/nix-darwin/nix-darwin-26.05"; inputs.nixpkgs.follows = "nixpkgs"; };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = { url = "github:homebrew/homebrew-core"; flake = false; };
    homebrew-cask = { url = "github:homebrew/homebrew-cask"; flake = false; };
    homebrew-rwx = { url = "github:rwx-cloud/homebrew-tap"; flake = false; };
    home-manager = { url = "github:nix-community/home-manager/release-26.05"; inputs.nixpkgs.follows = "nixpkgs"; };
    deploy-rs = { url = "github:serokell/deploy-rs"; inputs.nixpkgs.follows = "nixpkgs"; };
  };
  outputs = inputs: import ./nix { inherit inputs; };
}
