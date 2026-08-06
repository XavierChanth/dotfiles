{
  config,
  lib,
  pkgs,
  ...
}: let
  home = config.home.homeDirectory;
  signingKey = "${home}/.ssh/id_ed25519.pub";

  identities = [
    {
      id = "default";
      name = "xavierchanth";
      email = "xchanthavong@gmail.com";
      default = true;
      gitConditions = [];
      jjRepositories = [];
    }
    {
      id = "atsign";
      name = "xavierchanth";
      email = "xavier@atsign.com";
      default = false;
      gitConditions = [
        "hasconfig:remote.*.url:git@github.com:atsign-*/**"
        "gitdir:${home}/src/af/"
        "gitdir:${home}/src/ac/"
      ];
      jjRepositories = ["~/src/af/" "~/src/ac/"];
    }
    {
      id = "woosah";
      name = "xavierchanth";
      email = "xavier@woosah.io";
      default = false;
      gitConditions = [
        "hasconfig:remote.*.url:git@github.com:woosah-tech/**"
        "gitdir:${home}/src/ws/"
      ];
      jjRepositories = ["~/src/ws/"];
    }
    {
      id = "consulting";
      name = "xavierchanth";
      email = "xavier@chanthavongconsulting.ca";
      default = false;
      gitConditions = ["gitdir:${home}/src/cc/"];
      jjRepositories = ["~/src/cc/"];
    }
  ];

  defaultIdentity = lib.findFirst (identity: identity.default) null identities;
  identityPath = identity: "${home}/.config/git/user-${identity.id}";

  gitIdentityFiles = builtins.listToAttrs (map (identity: {
      name = ".config/git/user-${identity.id}";
      value.text = ''
        [user]
        name = ${identity.name}
        email = ${identity.email}
        signingkey = ${signingKey}
      '';
    })
    identities);

  conditionalGitIncludes = lib.concatMap (identity:
    map (condition: {
      inherit condition;
      path = identityPath identity;
    })
    identity.gitConditions)
  identities;

  jjIdentityConfig = {
    user = {
      inherit (defaultIdentity) name email;
    };
    "--scope" = map (identity: {
      "--when".repositories = identity.jjRepositories;
      user = {
        inherit (identity) name email;
      };
    }) (builtins.filter (identity: identity.jjRepositories != []) identities);
  };

  toml = pkgs.formats.toml {};
in {
  assertions = [
    {
      assertion = defaultIdentity != null;
      message = "Exactly one default identity must be configured.";
    }
    {
      assertion = lib.length (builtins.filter (identity: identity.default) identities) == 1;
      message = "Exactly one default identity must be configured.";
    }
  ];

  home.file = gitIdentityFiles;

  programs.git.includes = [
    {path = identityPath defaultIdentity;}
  ] ++ conditionalGitIncludes;

  xdg.configFile."jj/conf.d/10-identities.toml".source =
    toml.generate "jj-identities.toml" jjIdentityConfig;
}
