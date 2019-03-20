{ config, lib, pkgs, ... }:
{
  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };
  nixpkgs.config = {
      allowUnfree = true; # Allow "unfree" packages.
      packageOverrides = pkgs_: with pkgs_; {
      my_vim = import /worknix/nix/vim-config { inherit pkgs ; };
      };
  };

  security.sudo.wheelNeedsPassword = false;
 
  virtualisation.docker.enable = true;

  imports = [
    "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos"
  ];

  users.users.vagrant = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = ["docker" "wheel"];
  };
   
  home-manager.users.vagrant = {
    home.packages = with pkgs; [
      my_vim
      tmux
    ];
    programs.zsh = {
      enable = true;
      shellAliases = {
        "vi" = "vim";
        # "ssh" = "[[ `ssh-add -l` == \"The agent has no identities.\" ]] && ssh-add; ssh";
      };
      
      oh-my-zsh = {
        enable = true;
        theme = "nebirhos";
        plugins = [
          "tig"
          "tmux"
          "go"
          "dep"
          "git-extras"
          "git"
          "ssh-agent"
        ];
      };
      # identities need to be empty at first. Otherwise vagrant will fail ssh-ing into the machine because it asks for the 
      # passphrase at login
#      initExtra = ''
#zstyle :omz:plugins:ssh-agent identities
#'';
    };
      
    programs.tmux.enable = true;
    programs.tmux.terminal = "xterm-256color";
    programs.tmux.extraConfig = lib.fileContents /worknix/nix/tmux-config/tmux.conf;

    programs.git = {
      package = pkgs.gitAndTools.gitFull;
      enable = true;
      userEmail = "l@lucasvo.com";
      userName = "Lucas Vogelsang";
      extraConfig = {
        core = {
          editor = "vim";
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    autojump
    ack
    bash
 
    nix-prefetch-scripts
    nixpkgs-lint
    nox
    patchelf
    patchutils

    telnet
    bind

    gnumake

   
    inotify-tools 
    tree
    zip
    unzip
    fzf
    fd
    ripgrep
    glide
    wget
    curl
    htop
    whois
    autojump
    ack

    cloc
    jq
    go

    nodejs-8_x
    
    libffi
    gcc
    glibc
    stdenv

    python3
    python3.pkgs.pip
    python3.pkgs.virtualenv
    python3Packages.glances
    python3Packages.docker_compose

    home-manager
    git
    my_vim
    tmux
    dep
  ];	
}

