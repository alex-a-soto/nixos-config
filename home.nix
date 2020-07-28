{ config, pkgs, lib, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "alexander";
  home.homeDirectory = "/home/alexander";

  programs.firefox.enable = true;
  programs.obs-studio.enable = true;


  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
  };
};

  home.packages = with pkgs; [
    (let neuronSrc = builtins.fetchTarball https://github.com/srid/neuron/archive/master.tar.gz; in import neuronSrc {})

  ];

  programs.firefox = {
    extensions = lib.mkIf config.programs.firefox.enable (
      with pkgs.nur.repos.rycee.firefox-addons; [
        https-everywhere
        decentraleyes
        privacy-badger
        ublock-origin
        save-page-we
        keepassxc-browser
        multi-account-containers
        temporary-containers
        vimium
        link-cleaner
      ]
    );


    profiles = {
      default = {
        isDefault = true;
        settings = {
          "gfx.webrender.all" = true;
          "browser.startup.homepage"= "about:blank";
          "browser.newtabpage.enabled" = false;
          "browser.search.hiddenOneOffs" = "Google,Yahoo,Bing,Amazon.com,Twitter";
          "browser.search.suggest.enabled" = false;
          "browser.startup.page" = 3;
          "browser.tabs.closeWindowWithLastTab" = false;
          "browser.urlbar.placeholderName" = "DuckDuckGo";
          "experiments.activeExperiment" = false;
          "experiments.enabled" = false;
          "experiments.supported" = false;
          "extensions.pocket.enabled" = false;
          "general.smoothScroll" = false;
          "layout.css.devPixelsPerPx" = "1";
          "network.IDN_show_punycode" = true;
          "network.allow-experiments" = false;
          "signon.rememberSignons" = false;
        };
      };
    };
};

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.09";
}
