{inputs}: let
  inherit (inputs) nixpkgs nix-darwin home-manager;
  username = "chant";
  inventory = import ./inventory.nix;
  profiles = import ./profiles.nix;
  registry = import ./registry.nix;
  resolve = import ./lib/groups.nix { lib = nixpkgs.lib; };
  legacyProfile = profile: if nixpkgs.lib.hasSuffix "-workstation" profile then "workstation" else "server";
  contextFor = hostname: let
    host = inventory.${hostname};
    profileGroups = profiles.${host.profile} or (throw "unknown profile `${host.profile}` for ${hostname}");
    groupNames = profileGroups ++ (host.groups or []);
  in {
    inherit inputs username hostname inventory;
    hostProfile = host // { profileName = host.profile; profile = legacyProfile host.profile; };
    resolvedGroups = resolve { inherit registry; kind = host.kind; groups = groupNames; };
  };
  hostsOfKind = kind: nixpkgs.lib.filterAttrs (_: host:
    if !(host ? kind) then throw "inventory host is missing kind"
    else if builtins.elem host.kind [ "darwin" "nixos" ] then host.kind == kind
    else throw "unknown inventory kind `${host.kind}`") inventory;
  darwinHosts = hostsOfKind "darwin";
  nixosHosts = hostsOfKind "nixos";
  hostModules = kind: hostname: inventory.${hostname}.modules or [ ./hosts/${if kind == "darwin" then "darwin" else "nixos"}/${hostname} ];
  pkgsFor = system: import nixpkgs { inherit system; config.allowUnfree = true; };
  hmModule = context: { home-manager.useGlobalPkgs = true; home-manager.useUserPackages = true;
    home-manager.extraSpecialArgs = context;
    home-manager.users.${username}.imports = [ ./home/${username} ] ++ context.resolvedGroups.homeModules;
  };
  mkDarwin = hostname: let context = contextFor hostname; in nix-darwin.lib.darwinSystem {
    system = inventory.${hostname}.system; specialArgs = context;
    modules = hostModules "darwin" hostname ++ context.resolvedGroups.systemModules ++ [ home-manager.darwinModules.home-manager (hmModule context) ];
  };
  mkNixos = hostname: let context = contextFor hostname; in nixpkgs.lib.nixosSystem {
    system = inventory.${hostname}.system; specialArgs = context;
    modules = hostModules "nixos" hostname ++ context.resolvedGroups.systemModules ++ [ home-manager.nixosModules.home-manager (hmModule context) ];
  };
  mkHome = hostname: let context = contextFor hostname; in home-manager.lib.homeManagerConfiguration {
    pkgs = pkgsFor inventory.${hostname}.system; extraSpecialArgs = context;
    modules = [ ./home/${username} ] ++ context.resolvedGroups.homeModules;
  };
  attrs = names: f: builtins.listToAttrs (map (name: { inherit name; value = f name; }) names);
in {
  darwinConfigurations = attrs (builtins.attrNames darwinHosts) mkDarwin;
  nixosConfigurations = attrs (builtins.attrNames nixosHosts) mkNixos;
  homeConfigurations = builtins.listToAttrs (map (hostname: { name = "${username}@${hostname}"; value = mkHome hostname; }) (builtins.attrNames inventory));
}
