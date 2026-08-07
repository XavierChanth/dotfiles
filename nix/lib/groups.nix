{ lib }:
let
  fail = message: throw "group resolver: ${message}";
  duplicates = xs:
    lib.unique (lib.filter (x: lib.count (y: y == x) xs > 1) xs);
  ensure = condition: message: value: if condition then value else fail message;
  listOrEmpty = descriptor: field:
    let value = descriptor.${field} or [];
    in ensure (builtins.isList value) "${descriptor.name}.${field} must be a list" value;
  validateStow = group: item:
    ensure (builtins.isAttrs item && item ? name && builtins.isString item.name
      && item ? target && builtins.isString item.target
      && (!item ? prepare || (builtins.isList item.prepare && lib.all builtins.isString item.prepare)))
      "${group}: malformed Stow declaration" item;
in
{ registry, kind, groups }:
let
  _kind = ensure (builtins.elem kind [ "darwin" "nixos" ]) "unsupported kind `${kind}`" true;
  _groups = ensure (builtins.isList groups && lib.all builtins.isString groups) "groups must be a list of names" groups;
  repeated = duplicates _groups;
  _unique = ensure (repeated == []) "duplicate groups: ${lib.concatStringsSep ", " repeated}" true;
  missing = lib.filter (name: !(builtins.hasAttr name registry)) _groups;
  _known = ensure (missing == []) "unknown groups: ${lib.concatStringsSep ", " missing}" true;
  descriptors = map (name:
    let descriptor = registry.${name};
    in ensure (builtins.isAttrs descriptor && descriptor ? name && descriptor.name == name
      && descriptor ? platforms && builtins.isList descriptor.platforms
      && lib.all (p: builtins.elem p [ "darwin" "nixos" ]) descriptor.platforms)
      "malformed descriptor `${name}`"
      (ensure (builtins.elem kind descriptor.platforms) "group `${name}` does not support ${kind}" descriptor)
  ) _groups;
  facet = field: lib.concatMap (descriptor: listOrEmpty descriptor field) descriptors;
  incompatible = lib.concatMap (descriptor:
    (lib.optionals (kind != "darwin" && listOrEmpty descriptor "darwin" != []) [ descriptor.name ]) ++
    (lib.optionals (kind != "nixos" && listOrEmpty descriptor "nixos" != []) [ descriptor.name ])) descriptors;
  _facets = ensure (incompatible == []) "incompatible system facet in: ${lib.concatStringsSep ", " incompatible}" true;
  unorderedStow = lib.concatMap (descriptor: map (validateStow descriptor.name) (listOrEmpty descriptor "stow")) descriptors;
  stow = builtins.sort (a: b: (a.order or 1000) < (b.order or 1000)) unorderedStow;
  duplicatePackages = duplicates (map (x: x.name) stow);
  duplicateTargets = duplicates (map (x: x.target) stow);
  _stow = ensure (duplicatePackages == []) "duplicate Stow package owner: ${lib.concatStringsSep ", " duplicatePackages}"
    (ensure (duplicateTargets == []) "duplicate Stow target: ${lib.concatStringsSep ", " duplicateTargets}" true);
  brew = lib.concatMap (descriptor: listOrEmpty descriptor "brew") descriptors;
in builtins.seq _kind (builtins.seq _unique (builtins.seq _known (builtins.seq _facets (builtins.seq _stow {
  inherit stow brew;
  systemModules = facet kind;
  homeModules = facet "home";
}))))
