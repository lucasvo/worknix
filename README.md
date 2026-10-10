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
ripgrep, fd, jq, curl, htop, fzf, eza, powershell, cargo, rustc, k9s, databricks-cli, whisper-cpp

### Speech-to-text (whisper)
[whisper.cpp](https://github.com/ggml-org/whisper.cpp) built with Metal + CoreML, plus a `whisper`
wrapper that uses the `large-v3-turbo` model:

```bash
whisper memo.m4a                  # print transcript (any ffmpeg-readable format)
whisper memo.m4a -otxt -of memo   # also write memo.txt
whisper memo.m4a -osrt -l de      # German subtitles
whisper memo.m4a -l auto          # auto-detect language
```

The model (~1.6 GB) is downloaded to `~/.local/share/whisper-cpp` on first run.
Override with `WHISPER_MODEL=<name>` (e.g. `large-v3-turbo-q5_0`, `base.en`) or
`WHISPER_MODEL_DIR`. The raw `whisper-cli`, `whisper-server`, `whisper-stream` and
`whisper-cpp-download-ggml-model` binaries are on PATH too.

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
