# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’)

{ config, nixos-hardware, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
     <nixos-hardware/lenovo/thinkpad/x230>
      ./hardware-configuration.nix
    ];

  hardware = {
    cpu.intel.updateMicrocode = true;
    opengl.extraPackages = [ pkgs.beignet ];
  };

  powerManagement.powertop.enable = true;

  services = {
    acpid.enable = true;

    logind = {
      lidSwitch = "hybrid-sleep";
      lidSwitchDocked = "hybrid-sleep";

    };

    nixosManual.showManual = true;

    tlp = {
      enable = true;
      extraConfig = ''
        SATA_LINKPWR_ON_BAT=max_performance
        START_CHARGE_THRESH_BAT0=60
        STOP_CHARGE_THRESH_BAT0=80
        CPU_SCALING_GOVERNOR_ON_BAT=powersave
        ENERGY_PERF_POLICY_ON_BAT=powersave
      '';
    };

    upower.enable = true;
  };

 nixpkgs.config.allowUnfree = true;
 virtualisation.lxd.enable = true;



  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
   boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

   networking.hostName = "nixos"; # Define your hostname.
  #  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s25.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;
  networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
   i18n.defaultLocale = "en_US.UTF-8";
   console = {
     font = "Lat2-Terminus16";
     keyMap = "us";
   };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
# version control
     git
# interactive spell checker
     aspell
     aspellDicts.en
# the non-interactive network downloader
     wget 
# text editor
     vim
# text editor
     nano
# browser
     firefox
# terminal multiplexer
     tmux
# email client
     thunderbird
# editor
     emacs
# interactive process viewer
     htop
# frontedn for xrandr
     arandr
# load xrandr scripts
     autorandr
# simple terminal
     st
# simple webkit-based browser
     surf
# simple temperature control
     sct
# run arbitrary commands when files change
     entr
# monitors filesystem events and executes commands 
     incron
# viewer for remote, persistent x applications
     xpra
# simple x image viewer
     sxiv
# streaming and recording program
     obs-studio
# spaced reptition system
     anki
# browser
     # google-chrome
# file maanger
     xfce.thunar
    (xfce.thunar.override { thunarPlugins = [ xfce.thunar-archive-plugin xfce.thunar-volman ]; })
     xfce.gvfs
     samba
     fuse
     xfce.exo
     ffmpegthumbnailer
     xfce.tumbler
# notetaking stylus
     xournalpp
# secure messaging
     signal-desktop
# search tool
     ripgrep
# password manager
     keepassxc
# search tool
     recoll
# text editor
     atom
# audio recording/editing
     audacity
# synchronize files
     syncthing
# media player
     vlc
# office suite
     libreoffice
# document viewer
     zathura
# image manipulation and paint program
     gimp
# list contents of directories in tree-like format
     tree
# archive tool
     unzip
# C and C++ compiler
     gcc
# system info script
     neofetch
# general markup converter
     pandoc
# text editor
     micro
   ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services.openssh.enable = false;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the X11 windowing system.

  services.xserver.enable = true;
  services.xserver.autorun = true;
  services.xserver.layout = "us";

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.defaultSession = "none+i3";
  services.xserver.desktopManager.xterm.enable = false;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.windowManager.i3.enable = true;

   nix.allowedUsers = [ "@wheel" "alexander" ];


  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  
   users.users.alexander = {
     isNormalUser = true;
     extraGroups = [ "wheel" "network" "lxd"]; # Enable ‘sudo’ for the user.
   };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

}
