{ ... }:

{

  programs.emacs.extraPackages = epkgs: with {
    elpa = epkgs.elpaPackages;
    melpa = epkgs.melpaPackages;
    melpaStable = epkgs.melpaStablePackages;
  }; (
    with elpa; [

    ]
  ) ++ (
    with melpa; [
      better-defaults
    ]
  ) ++ (
    with melpaStable; [

    ]
  );

}
