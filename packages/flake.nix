{
  description = "Dotfiles package bundle flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      lib = nixpkgs.lib;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = f: lib.genAttrs systems f;
      importPackageList = pkgs: file: import file { inherit pkgs; };
      mkGroup =
        pkgs: name: file:
        pkgs.buildEnv {
          inherit name;
          paths = importPackageList pkgs file;
        };
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        {
          common = mkGroup pkgs "dotfiles-common" ./nix-common.nix;
          desktopCommon = mkGroup pkgs "dotfiles-desktop-common" ./nix-desktop-common.nix;
          linux = mkGroup pkgs "dotfiles-linux" ./nix-linux.nix;
          desktopLinux = mkGroup pkgs "dotfiles-desktop-linux" ./nix-desktop-linux.nix;
          macos = mkGroup pkgs "dotfiles-macos" ./nix-macos.nix;
          desktopMacos = mkGroup pkgs "dotfiles-desktop-macos" ./nix-desktop-macos.nix;
          default =
            if pkgs.stdenv.isDarwin then
              mkGroup pkgs "dotfiles-default-macos" ./nix-common.nix
            else
              mkGroup pkgs "dotfiles-default-linux" ./nix-common.nix;
        }
      );
    };
}
