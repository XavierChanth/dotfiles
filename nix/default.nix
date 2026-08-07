{inputs}: let
  inherit (inputs) nixpkgs nix-darwin home-manager;
  lib = nixpkgs.lib;
  username = "chant";
  inventory = import ./inventory.nix;
  profiles = import ./profiles.nix;
  registry = import ./registry.nix;
  resolve = import ./lib/groups.nix { inherit lib; };
  profileKinds = {
    darwin-workstation = { kind = "darwin"; legacy = "workstation"; };
    darwin-server = { kind = "darwin"; legacy = "server"; };
    linux-workstation = { kind = "nixos"; legacy = "workstation"; };
    linux-server = { kind = "nixos"; legacy = "server"; };
  };
  declarationFor = kind: hostname: let
    path = if kind == "darwin" then ./hosts/darwin/${hostname} else if kind == "nixos" then ./hosts/nixos/${hostname}
      else throw "no host declaration dispatch for `${kind}`";
    value = import path;
    valid = builtins.isAttrs value
      && value ? groups && builtins.isList value.groups && lib.all builtins.isString value.groups
      && value ? modules && builtins.isList value.modules && lib.all (module: builtins.isPath module) value.modules;
  in if valid then value else throw "host declaration `${hostname}` must be an attribute set with string-list `groups` and path-list `modules`";
  contextFor = hostname: let
    host = inventory.${hostname};
    mapping = profileKinds.${host.profile} or (throw "unknown profile `${host.profile}` for ${hostname}");
    _compatible = if mapping.kind == host.kind then true else throw "profile `${host.profile}` does not support ${host.kind}";
    profileGroups = profiles.${host.profile} or (throw "unknown profile `${host.profile}` for ${hostname}");
    declaration = declarationFor host.kind hostname;
    groupNames = profileGroups ++ (host.groups or []) ++ declaration.groups;
  in builtins.seq _compatible {
    inherit inputs username hostname inventory;
    hostProfile = host // { profileName = host.profile; profile = mapping.legacy; };
    resolvedGroups = resolve { inherit registry; kind = host.kind; groups = groupNames; };
  };
  validKinds = map (hostname: let host = inventory.${hostname}; in
    if !(host ? kind) then throw "inventory host `${hostname}` is missing kind"
    else if builtins.elem host.kind [ "darwin" "nixos" "openwrt" ] then true
    else throw "unknown inventory kind `${host.kind}`") (builtins.attrNames inventory);
  hostsOfKind = kind: lib.filterAttrs (_: host: host.kind == kind) inventory;
  darwinHosts = hostsOfKind "darwin";
  nixosHosts = hostsOfKind "nixos";
  hostModules = kind: hostname:
    (declarationFor kind hostname).modules ++ (inventory.${hostname}.extraModules or []);
  pkgsFor = system: import nixpkgs { inherit system; config.allowUnfree = true; };
  hmModule = context: { home-manager.useGlobalPkgs = true; home-manager.useUserPackages = true;
    home-manager.extraSpecialArgs = context;
    home-manager.users.${username}.imports = [ ./home/${username} ] ++ context.resolvedGroups.homeModules;
  };
  mkDarwin = hostname: let context = contextFor hostname; in nix-darwin.lib.darwinSystem {
    system = inventory.${hostname}.system; specialArgs = context;
    modules = hostModules "darwin" hostname ++ context.resolvedGroups.systemModules ++ [ home-manager.darwinModules.home-manager (hmModule context) ];
  };
  mkNixos = hostname: let context = contextFor hostname; in lib.nixosSystem {
    system = inventory.${hostname}.system; specialArgs = context;
    modules = hostModules "nixos" hostname ++ context.resolvedGroups.systemModules ++ [ home-manager.nixosModules.home-manager (hmModule context) ];
  };
  mkHome = hostname: let context = contextFor hostname; in home-manager.lib.homeManagerConfiguration {
    pkgs = pkgsFor inventory.${hostname}.system; extraSpecialArgs = context;
    modules = [ ./home/${username} ] ++ context.resolvedGroups.homeModules;
  };
  attrs = names: f: builtins.listToAttrs (map (name: { inherit name; value = f name; }) names);
  supportedHomeHosts = darwinHosts // nixosHosts;
  resolverTests = import ./tests/groups.nix { inherit lib; };
  profileTests = lib.all (name: let mapping = profileKinds.${name}; in
    (resolve { inherit registry; kind = mapping.kind; groups = profiles.${name}; }) ? homeModules)
    (builtins.attrNames profileKinds);
  linuxWorkstation = resolve {
    inherit registry;
    kind = "nixos";
    groups = profiles.linux-workstation;
  };
  linuxWorkstationHome = home-manager.lib.homeManagerConfiguration {
    pkgs = pkgsFor "x86_64-linux";
    modules = linuxWorkstation.homeModules ++ [{
      home.username = "foundation-test";
      home.homeDirectory = "/home/foundation-test";
      home.stateVersion = "26.05";
    }];
  };
  checked = builtins.deepSeq validKinds (assert resolverTests; assert profileTests; true);
in builtins.seq checked {
  darwinConfigurations = attrs (builtins.attrNames darwinHosts) mkDarwin;
  nixosConfigurations = attrs (builtins.attrNames nixosHosts) mkNixos;
  homeConfigurations = builtins.listToAttrs (map (hostname: { name = "${username}@${hostname}"; value = mkHome hostname; }) (builtins.attrNames supportedHomeHosts));
  checks = lib.recursiveUpdate
    (lib.genAttrs [ "aarch64-darwin" "x86_64-linux" ] (system: {
      resolver = (pkgsFor system).runCommand "resolver-tests" {} "touch $out";
    }))
    { x86_64-linux.linux-workstation-home = linuxWorkstationHome.activationPackage; };
}
