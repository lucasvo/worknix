{ config, pkgs, ... }:

{
  home.username = "lucasvo";
  home.homeDirectory = "/Users/lucasvo";

  home.stateVersion = "24.05";

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    ripgrep
    fd
    jq
    curl
    htop
    powershell
    fzf
    eza
    cargo
    rustc
  ];

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.foundry/bin"
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    lfs.enable = true;
    signing.format = null;
    settings = {
      user.name = "lucasvo";
      user.email = "l@lucasvo.com";
      init.defaultBranch = "main";
      core.pager = "less -FX";
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      # Telescope (fuzzy finder)
      telescope-nvim
      plenary-nvim

      # Treesitter (syntax highlighting, indentation, folds)
      nvim-treesitter.withAllGrammars

      # LSP
      nvim-lspconfig

      # Completion
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path

      # Formatting
      conform-nvim

      # UI
      lualine-nvim
      nvim-web-devicons
      indent-blankline-nvim

      # Git
      vim-fugitive
      gv-vim
      gitsigns-nvim

      # File browser
      oil-nvim

      # Zen / focus
      zen-mode-nvim
      twilight-nvim

      # Misc
      rainbow-delimiters-nvim
      tabular
    ];
    initLua = (builtins.readFile dotfiles/neovim.lua);
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      o = "open";
      ls = "eza";
      ll = "eza -la";
      lt = "eza --tree";
    };
    initContent = ''
      export ZSH_CUSTOM=$HOME/.config/oh-my-zsh
      export FZF_BASE=${pkgs.fzf}/share/fzf/

      # NVM
      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

      # Google Cloud SDK (adds gcloud bin incl. gke-gcloud-auth-plugin to PATH)
      [ -f "/opt/homebrew/share/google-cloud-sdk/path.zsh.inc" ] && \. "/opt/homebrew/share/google-cloud-sdk/path.zsh.inc"
      [ -f "/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc" ] && \. "/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc"

      # Prod-admin (PAM-elevated adm.* work): isolated gcloud/kubectl config
      # scoped to a subshell in the CURRENT tab — never touches the normal
      # lucasvo@tare.io session state, and `exit` returns you to the tab
      # exactly as it was before.
      prod-admin() {
        (
          export CLOUDSDK_CONFIG="$HOME/adm-session/gcloud"
          export KUBECONFIG="$HOME/adm-session/kubeconfig"
          mkdir -p "$CLOUDSDK_CONFIG"

          printf '\033]0;PROD ADMIN — adm.* session\007'   # tab title
          printf '\033]11;#330000\007'                      # dark red background
          # Reset title + background no matter how this subshell exits
          # (exit, Ctrl-D, Ctrl-C, killed, etc).
          trap 'printf "\033]0;\007"; printf "\033]111\007"' EXIT

          export PROMPT="%F{red}%B[ADM PROD]%b%f $PROMPT"

          print -P "%F{red}%B>>> Isolated prod-admin session (adm.* identity)%b%f"
          print -P "%F{red}>>> CLOUDSDK_CONFIG=$CLOUDSDK_CONFIG%f"
          print -P "%F{red}>>> KUBECONFIG=$KUBECONFIG%f"
          print -P "%F{red}>>> Run 'gcloud auth login' to sign in as your adm.* account.%f"
          print -P "%F{red}>>> Type 'exit' to leave this session and restore the background.%f"

          zsh
        )
      }
    '';
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.4.0";
          sha256 = "037wz9fqmx0ngcwl9az55fgkipb745rymznxnssr3rx9irb6apzg";
        };
      }
    ];
    oh-my-zsh = {
      enable = true;
      plugins = [
        "gitfast"
        "git-extras"
        "sudo"
        "fzf"
      ];
      custom = "$HOME/.config/oh-my-zsh";
      theme = "robbyrussell";
    };
  };

  home.file = {
    ".config/oh-my-zsh/plugins/nix-shell".source = pkgs.fetchFromGitHub {
      owner = "chisui";
      repo = "zsh-nix-shell";
      rev = "b2609ca787803f523a18bb9f53277d0121e30389";
      sha256 = "01w59zzdj12p4ag9yla9ycxx58pg3rah2hnnf3sw4yk95w3hlzi6";
    };
  };

  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
  };
}
