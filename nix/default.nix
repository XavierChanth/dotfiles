{inputs}: let
  inherit (inputs) nixpkgs nix-darwin home-manager;
  username = "chant";
  inventory = import ./inventory.nix;
  isDarwin = _: host: nixpkgs.lib.hasSuffix "-darwin" host.system;
  darwinHosts = nixpkgs.lib.filterAttrs isDarwin inventory;
  nixosHosts = builtins.removeAttrs inventory (builtins.attrNames darwinHosts);
  specialArgsFor = hostname: { inherit inputs username hostname inventory; hostProfile = inventory.${hostname}; };
  pkgsFor = system: import nixpkgs { inherit system; config.allowUnfree = true; };
  mkDarwin = hostname: nix-darwin.lib.darwinSystem {
    system = inventory.${hostname}.system; specialArgs = specialArgsFor hostname;
    modules = [ ./hosts/darwin/${hostname} home-manager.darwinModules.home-manager {
      home-manager.useGlobalPkgs = true; home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = specialArgsFor hostname;
      home-manager.users.${username} = import ./home/${username};
    } ];
  };
  mkNixos = hostname: nixpkgs.lib.nixosSystem {
    system = inventory.${hostname}.system; specialArgs = specialArgsFor hostname;
    modules = [ ./hosts/nixos/${hostname} home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true; home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = specialArgsFor hostname;
      home-manager.users.${username} = import ./home/${username};
    } ];
  };
  mkHome = hostname: home-manager.lib.homeManagerConfiguration {
    pkgs = pkgsFor inventory.${hostname}.system; extraSpecialArgs = specialArgsFor hostname;
    modules = [ ./home/${username} ];
  };
  attrs = names: f: builtins.listToAttrs (map (name: { inherit name; value = f name; }) names);
in {
  darwinConfigurations = attrs (builtins.attrNames darwinHosts) mkDarwin;
  nixosConfigurations = attrs (builtins.attrNames nixosHosts) mkNixos;
  homeConfigurations = builtins.listToAttrs (map (hostname: {
    name = "${username}@${hostname}";
    value = mkHome hostname;
  }) (builtins.attrNames inventory));
}
