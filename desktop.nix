# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’)

{ config, pkgs, lib, options, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration-desktop.nix
      ./modules/syncthing.nix
    ];
#    nixosManual.showManual = true;

boot.initrd.luks.devices = [
  { 
    name = "root";
    device = "/dev/nvme1n1p2";
    preLVM = true;
  }
];

 nixpkgs.config.allowUnfree = true;
 virtualisation.lxd.enable = true;
 virtualisation.libvirtd.enable = true;

  virtualisation.docker = {
    enable = true;
    # Only load docker service, but make it inactive. A command on the
    # docker cli (e.g., `docker ps` or `docker run`) will activate it.
    enableOnBoot = false;
    # Do `docker system prune -f` periodically.
    autoPrune.enable = true;
  };
  users.extraGroups.docker.members = [ "alexander" ];


  ## Use the GRUB 2 boot loader.
   boot.loader.grub.enable = true;
   boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
   boot.loader.grub.device = "nodev"; # or "nodev" for efi only
   boot.loader.efi.canTouchEfiVariables = true;
   boot.loader.grub.efiSupport = true;
   boot.loader.systemd-boot.enable = true;
   boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
   boot.kernelModules = [ "v4l2loopback" ];
   boot.extraModprobeConfig = ''
         options v4l2loopback exclusive_caps=1 video_nr=9 card_label="OBS Camera"
	     '';

    boot.kernelPackages = pkgs.linuxPackages_latest;

   networking.hostName = "alpha"; # Define your hostname.
  #  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
 # networking.useDHCP = true;
  networking.interfaces.enp68s0.useDHCP = true;
  networking.interfaces.enp70s0.useDHCP = true;
  networking.interfaces.wlp69s0.useDHCP = true;
  networking.networkmanager.enable = true;

  networking.firewall = {
    allowedTCPPortRanges = [ 
      { from = 1714; to = 1764; } # KDEConnect
    ];
    allowedUDPPortRanges = [      
      { from = 1714; to = 1764; } # KDEConnect
    ];
  };


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

  # Garbage collection
#  nix.gc = {
#    automatic = true;
#    dates = "weekly";
#    options = "--delete-older-than 30d";
#  };

  nix.trustedUsers = [ "root" "alexander" ];


  # List packages installed in system profile. To search, run:
  # $ nix search wget
 environment.systemPackages = with pkgs; [
  xsensors
  lm_sensors
  psensor
  nixUnstable
# version control
  git
# interactive spell checker
  aspell
  aspellDicts.en
  networkmanagerapplet
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
  v4l-utils
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
  unstable.obs-studio

  unstable.obs-v4l2sink
# spaced reptition system
  anki
# browser
  google-chrome
# file maanger
  kitty
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
  usbutils
  lshw
  pciutils
# password manager
  unstable.keepassxc
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
  unrar
# C and C++ compiler
  gcc
# system info script
  neofetch
# general markup converter
  pandoc
# text editor
  gparted
  ffmpeg-full

# VM dependencies
  kvm qemu libvirt bridge-utils virt-manager
  virt-viewer spice-vdagent

  kdeconnect

  workrave

  # PulseAudio control
    # ------------------
    pavucontrol
    pulseaudio-ctl
    pasystray
     
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

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];

  # Enable sound.	
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    package = pkgs.pulseaudioFull;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
  };

  # Enable bluetooth.
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluezFull;
    config.General.Enable = "Source,Sink,Media,Socket";
  };

  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz"){
      inherit pkgs;
    };
    unstable = import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz")
     {
      config = config.nixpkgs.config;
    };
  };




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
  services.xserver.videoDrivers = [ "amdgpu" ];

   nix.allowedUsers = [ "@wheel" "alexander" ];
   
  
   users.users.alexander = {
     isNormalUser = true;
     extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "network" "lxd"]; # Enable ‘sudo’ for the user.
     group = "users";
     home = "/home/alexander";
     uid = 1000;
   };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

}
