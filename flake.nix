{
  description = "Cross-platform-ready dotfiles flake with nix-darwin and Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    homebrew-steipete = {
      url = "github:steipete/homebrew-tap";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };
  };

  outputs = inputs@{
    self,
    nixpkgs,
    nix-darwin,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    home-manager,
    neovim-nightly-overlay,
    ...
  }: let
    username = "chant";
    system = "aarch64-darwin";
    darwinHosts = {
      eris = {
        isRemote = true;
      };
      nyx = {
        isRemote = false;
      };
    };
    darwinHostnames = builtins.attrNames darwinHosts;

    specialArgsFor = hostname: let
      hostProfile = darwinHosts.${hostname};
    in {
      inherit inputs username hostname system hostProfile;
    };

    pkgsFor = targetSystem:
      import nixpkgs {
        system = targetSystem;
        config.allowUnfree = true;
      };

    mkDarwinConfiguration = hostname:
      nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = specialArgsFor hostname;
        modules = [
          ./hosts/darwin/${hostname}
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = specialArgsFor hostname;
            home-manager.users.${username} = import ./home/${username};
          }
        ];
      };

    mkHomeConfiguration = hostname:
      home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor system;
        extraSpecialArgs = specialArgsFor hostname;
        modules = [
          ./home/${username}
        ];
      };
  in {
    darwinConfigurations = builtins.listToAttrs (map (hostname: {
        name = hostname;
        value = mkDarwinConfiguration hostname;
      })
      darwinHostnames);

    homeConfigurations = builtins.listToAttrs (map (hostname: {
        name = "${username}@${hostname}";
        value = mkHomeConfiguration hostname;
      })
      darwinHostnames);
  };
}
