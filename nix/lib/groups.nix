{ lib }:
let
  fail = message: throw "group resolver: ${message}";
  ensure = condition: message: value: if condition then value else fail message;
  duplicates = xs: lib.unique (lib.filter (x: lib.count (y: y == x) xs > 1) xs);
  listOrEmpty = descriptor: field:
    let value = descriptor.${field} or [];
    in ensure (builtins.isList value) "${descriptor.name}.${field} must be a list" value;
  validateStrings = group: field: value:
    ensure (builtins.isList value && lib.all builtins.isString value)
      "${group}.brew.${field} must be a list of strings" value;
  validateBrew = descriptor:
    let
      value = descriptor.brew or { taps = []; brews = []; casks = []; };
      fields = builtins.attrNames value;
      allowed = [ "taps" "brews" "casks" ];
      unknown = lib.filter (field: !(builtins.elem field allowed)) fields;
    in ensure (builtins.isAttrs value && unknown == [] && lib.all (field: builtins.hasAttr field value) allowed)
      "${descriptor.name}.brew must contain only taps, brews, and casks"
      {
        taps = validateStrings descriptor.name "taps" value.taps;
        brews = validateStrings descriptor.name "brews" value.brews;
        casks = validateStrings descriptor.name "casks" value.casks;
      };
  validateStow = group: item:
    ensure (builtins.isAttrs item && item ? name && builtins.isString item.name
      && item ? target && builtins.isString item.target
      && (!item ? prepare || (builtins.isList item.prepare && lib.all builtins.isString item.prepare)))
      "${group}: malformed Stow declaration" item;
in
{ registry, kind, groups }:
let
  _kind = ensure (builtins.elem kind [ "darwin" "nixos" "openwrt" ]) "unsupported kind `${kind}`" true;
  _groups = ensure (builtins.isList groups && lib.all builtins.isString groups) "groups must be a list of names" groups;
  repeated = duplicates _groups;
  _unique = ensure (repeated == []) "duplicate groups: ${lib.concatStringsSep ", " repeated}" true;
  missing = lib.filter (name: !(builtins.hasAttr name registry)) _groups;
  _known = ensure (missing == []) "unknown groups: ${lib.concatStringsSep ", " missing}" true;
  descriptors = map (name:
    let descriptor = registry.${name};
    in ensure (builtins.isAttrs descriptor && descriptor ? name && descriptor.name == name
      && descriptor ? platforms && builtins.isList descriptor.platforms
      && lib.all (p: builtins.elem p [ "darwin" "nixos" "openwrt" ]) descriptor.platforms)
      "malformed descriptor `${name}`"
      (ensure (builtins.elem kind descriptor.platforms) "group `${name}` does not support ${kind}" descriptor)
  ) _groups;
  invalidFacets = lib.concatMap (descriptor: lib.concatMap (facet:
    lib.optionals (listOrEmpty descriptor facet != [] && !(builtins.elem facet descriptor.platforms)) [ "${descriptor.name}.${facet}" ])
    [ "darwin" "nixos" "openwrt" ]) descriptors;
  _facets = ensure (invalidFacets == []) "facet not declared in platforms: ${lib.concatStringsSep ", " invalidFacets}" true;
  unmet = lib.concatMap (descriptor: map (required: "${descriptor.name} requires ${required}")
    (lib.filter (required: !(builtins.elem required _groups))
      (ensure (lib.all builtins.isString (listOrEmpty descriptor "requires")) "${descriptor.name}.requires must contain names" (listOrEmpty descriptor "requires")))) descriptors;
  _requires = ensure (unmet == []) (lib.concatStringsSep "; " unmet) true;
  credentialAllowList = [ "github-api" ];
  credentialLists = map (descriptor: let value = listOrEmpty descriptor "deployCredentials";
    unknown = lib.filter (name: !(builtins.elem name credentialAllowList)) value;
    in ensure (lib.all builtins.isString value && unknown == [])
      "${descriptor.name}.deployCredentials contains unsupported names: ${lib.concatStringsSep ", " unknown}" value) descriptors;
  deployCredentials = lib.unique (lib.concatLists credentialLists);
  unorderedStow = lib.concatMap (descriptor: map (validateStow descriptor.name) (listOrEmpty descriptor "stow")) descriptors;
  stow = builtins.sort (a: b: (a.order or 1000) < (b.order or 1000)) unorderedStow;
  duplicatePackages = duplicates (map (x: x.name) stow);
  duplicateTargets = duplicates (map (x: x.target) stow);
  _stow = ensure (duplicatePackages == []) "duplicate Stow package owner: ${lib.concatStringsSep ", " duplicatePackages}"
    (ensure (duplicateTargets == []) "duplicate Stow target: ${lib.concatStringsSep ", " duplicateTargets}" true);
  brews = map (descriptor: ensure ((descriptor.brew or null) == null || builtins.elem "darwin" descriptor.platforms)
    "${descriptor.name}.brew requires Darwin support" (validateBrew descriptor)) descriptors;
  brew = {
    taps = lib.unique (lib.concatMap (x: x.taps) brews);
    brews = lib.unique (lib.concatMap (x: x.brews) brews);
    casks = lib.unique (lib.concatMap (x: x.casks) brews);
  };
  result = {
    inherit stow brew deployCredentials;
    systemModules = lib.concatMap (descriptor: listOrEmpty descriptor kind) descriptors;
    homeModules = lib.concatMap (descriptor: listOrEmpty descriptor "home" ++ listOrEmpty descriptor "${kind}Home") descriptors;
  };
in builtins.seq _kind (builtins.seq _unique (builtins.seq _known (builtins.seq _facets
  (builtins.seq _requires (builtins.seq _stow (builtins.deepSeq brew result))))))
