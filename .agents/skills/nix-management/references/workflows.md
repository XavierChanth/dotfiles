# Nix Management Workflows

## Contents

1. Repo inspection
2. Validation decision guide
3. Common command patterns
4. Lockfile guidance
5. Troubleshooting cues

## Repo inspection

Start with file discovery:

```bash
rg --files . | rg '(^|/)(flake\.nix|flake\.lock|default\.nix|shell\.nix|.*\.nix)$'
rg -n 'darwinConfigurations|nixosConfigurations|homeConfigurations|devShells|packages|checks|overlays' .
```

Look for these ownership hints:

- `hosts/`, `machines/`, `darwin/`, `nixos/`: system-level modules
- `home/`, `users/`, `home-manager/`: user-level modules
- `pkgs/`, `packages/`, `overlays/`: package definitions or overrides
- `shells/`, `devshell/`: developer environment outputs

If the repo is large, summarize first instead of opening every file.

## Validation decision guide

Use the narrowest command that proves the requested behavior:

| Change type | Prefer first | Escalate only if needed |
| --- | --- | --- |
| General flake refactor | `nix flake check` | targeted builds for affected outputs |
| Package or overlay change | `nix build .#<attr>` | host/user config build |
| Dev shell change | `nix develop .#<shell> -c <cmd>` | full `nix develop` session |
| Home Manager module | `home-manager build --flake .#<name>` | `home-manager switch --flake .#<name>` |
| nix-darwin module | `darwin-rebuild build --flake .#<host>` | `darwin-rebuild switch --flake .#<host>` |
| NixOS module | `nixos-rebuild build --flake .#<host>` | `nixos-rebuild switch|boot --flake .#<host>` |
| Input update | targeted build/check after lock change | broader rebuild if impact is wide |

If you do not know the exact attribute name, inspect `flake.nix` and nearby modules before guessing.

## Common command patterns

### Show flake outputs

```bash
nix flake show
nix flake show . --all-systems
```

### Evaluate or build a specific output

```bash
nix build .#packages.aarch64-darwin.<name>
nix build .#packages.x86_64-linux.<name>
nix eval .#darwinConfigurations.<host>.pkgs.stdenv.hostPlatform.system
```

### Validate dev shells

```bash
nix develop .#default -c command -v <tool>
nix develop .#<shell> -c <command>
```

### Build without switching

```bash
home-manager build --flake .#<user>
darwin-rebuild build --flake .#<host>
sudo nixos-rebuild build --flake .#<host>
```

### Apply only when requested

```bash
home-manager switch --flake .#<user>
darwin-rebuild switch --flake .#<host>
sudo nixos-rebuild switch --flake .#<host>
```

## Lockfile guidance

Treat `flake.lock` as a deliberate change:

- Prefer `nix flake lock --update-input <input>` over broad updates when the task targets one dependency.
- Review the lock diff for unexpected transitive churn.
- Mention that updating inputs may trigger downloads and large rebuilds.
- Revalidate the affected outputs after any lockfile change.

## Troubleshooting cues

### Syntax or parse errors

Inspect the line mentioned in the error and the surrounding list, attribute set, or `let`/`in` structure. Missing semicolons and braces are common.

### Missing attribute errors

Confirm the exact output path in `flake.nix`. Many failures come from using the wrong system key or output namespace.

### Option collisions or type errors

Inspect merged modules and repeated option assignments. Look for `mkIf`, `mkMerge`, `mkDefault`, and whether a list or attrset is being combined incorrectly.

### Infinite recursion

Look for self-references through `pkgs`, overlays, or module arguments. Reduce indirection and evaluate the smallest failing path first.
