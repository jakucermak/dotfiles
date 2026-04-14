# dotfiles

## Prerequisites

### Install Nix

```bash
curl -L https://nixos.org/nix/install | sh
```

### Install nix-darwin

```bash
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer
```

Or using flakes (recommended):

```bash
nix run nix-darwin -- switch --flake .#mcbp
```

## Install / Apply Configuration

```bash
nix run github:jakucermak/dotfiles#darwinConfigurations."mcbp".system -- switch
```

Or locally:

```bash
darwin-rebuild switch --flake .#mcbp
```

## Update Flake Inputs

Update all inputs:

```bash
nix flake update
```

Update a specific input:

```bash
nix flake lock --update-input nixpkgs
nix flake lock --update-input home-manager
```

## Useful Commands

```bash
# Show flake outputs
nix flake show

# Check flake for errors
nix flake check

# Garbage collect old generations
nix-collect-garbage -d

# List generations
darwin-rebuild --list-generations

# Rollback to previous generation
darwin-rebuild --rollback

# Build without switching (dry run)
darwin-rebuild build --flake .#mcbp
```
