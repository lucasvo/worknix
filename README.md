# worknix
My work environment the way I like it, configured with nix and home-manager. Targets macOS (aarch64-darwin).

## Setup

### Prerequisites
- [Nix](https://install.determinate.systems/nix) with flakes enabled
- [NVM](https://github.com/nvm-sh/nvm) (managed outside nix, sourced in zsh)
- [Foundry](https://getfoundry.sh/) via `foundryup` (managed outside nix)

### First install
```bash
nix run home-manager/master -- switch --flake ~/worknix#lucasvo -b backup
```

### Updating after changes
```bash
home-manager switch --flake ~/worknix#lucasvo
```

## What's managed

### CLI tools
ripgrep, fd, jq, curl, htop, fzf, eza, powershell, cargo, rustc

### Programs
- **git** — LFS, default branch `main`
- **neovim** — modern lua config with treesitter, telescope, LSP, nvim-cmp, conform, fugitive, gitsigns, oil, zen-mode
- **zsh** — oh-my-zsh (robbyrussell theme), autosuggestions, syntax highlighting, fzf integration, nix-shell indicator
- **tmux** — 256color terminal

### Shell aliases
| Alias | Command |
|-------|---------|
| `o` | `open` |
| `ls` | `eza` |
| `ll` | `eza -la` |
| `lt` | `eza --tree` |

### PATH additions
- `~/.local/bin`
- `~/.foundry/bin`
- NVM-managed Node (via `~/.nvm/nvm.sh`)

## Structure
```
flake.nix          # Nix flake (nixpkgs + home-manager inputs)
home.nix           # Home-manager configuration
dotfiles/
  neovim.lua       # Neovim lua config
  robbyrussell-nix.zsh-theme  # Custom zsh theme with nix-shell indicator
```

## Inspirations
- https://github.com/nocoolnametom/nix-configs
- https://github.com/yrashk/nix-home
- https://github.com/bobvanderlinden/nix-home/
