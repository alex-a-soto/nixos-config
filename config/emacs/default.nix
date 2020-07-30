{ config, lib, pkgs, ... }:

{

  imports = [
    ./packages.nix
  ];

  home.file.".emacs.d/init.el".source = ./init.el;

  home.sessionVariables = rec {
    EDITOR = ''emacsclient -nw -a \"\"'';
    GIT_EDITOR = EDITOR;
    VISUAL = ''emacsclient -cna \"\"'';
  };

  programs.emacs.enable = true;


}
