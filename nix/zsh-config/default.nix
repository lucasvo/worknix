{config, pkgs, ...}:
{
pkgs.writeText "zshrc" ''
# export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh/
source "$(autojump-share)/autojump.bash"
''
};
