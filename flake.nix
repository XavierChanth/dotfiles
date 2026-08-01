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

    homebrew-rwx = {
      url = "github:rwx-cloud/homebrew-tap";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{
    self,
    nixpkgs,
    nix-darwin,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    homebrew-rwx,
    home-manager,
    ...
  }: let
    username = "chant";
    darwinHosts = {
      eris = {
        system = "aarch64-darwin";
        profile = "server";
      };
      nyx = {
        system = "aarch64-darwin";
        profile = "workstation";
      };
    };
    darwinHostnames = builtins.attrNames darwinHosts;

    nixosHosts = {
      hades = {
        system = "x86_64-linux";
        profile = "server";
      };
      poseidon = {
        system = "x86_64-linux";
        profile = "server";
      };
      zeus = {
        system = "x86_64-linux";
        profile = "server";
      };
    };
    nixosHostnames = builtins.attrNames nixosHosts;
    allHosts = darwinHosts // nixosHosts;
    allHostnames = builtins.attrNames allHosts;

    specialArgsFor = hostname: let
      hostProfile = allHosts.${hostname};
    in {
      inherit inputs username hostname hostProfile;
    };

    pkgsFor = targetSystem:
      import nixpkgs {
        system = targetSystem;
        config.allowUnfree = true;
      };

    mkDarwinConfiguration = hostname:
      nix-darwin.lib.darwinSystem {
        system = darwinHosts.${hostname}.system;
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
        pkgs = pkgsFor allHosts.${hostname}.system;
        extraSpecialArgs = specialArgsFor hostname;
        modules = [
          ./home/${username}
        ];
      };

    mkNixosConfiguration = hostname:
      nixpkgs.lib.nixosSystem {
        system = nixosHosts.${hostname}.system;
        specialArgs = specialArgsFor hostname;
        modules = [
          ./hosts/nixos/${hostname}
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = specialArgsFor hostname;
            home-manager.users.${username} = import ./home/${username};
          }
        ];
      };
  in {
    darwinConfigurations = builtins.listToAttrs (map (hostname: {
        name = hostname;
        value = mkDarwinConfiguration hostname;
      })
      darwinHostnames);

    nixosConfigurations = builtins.listToAttrs (map (hostname: {
        name = hostname;
        value = mkNixosConfiguration hostname;
      })
      nixosHostnames);

    homeConfigurations = builtins.listToAttrs (map (hostname: {
        name = "${username}@${hostname}";
        value = mkHomeConfiguration hostname;
      })
      allHostnames);
  };
}
