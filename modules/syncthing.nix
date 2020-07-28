{ config, options, lib, pkgs, ... }:

with lib;

{
  services.syncthing =
    let
      hostname = config.networking.hostName;
    in {
      enable = true;
      user = "alexander";
      configDir = "${config.users.users.alexander.home}/.config/syncthing";
      openDefaultPorts = true;

      # I have to copy this from my private secret folder
      # declarative.cert = builtins.toPath "/etc/nixos/secret/${hostname}-syncthing-cert.pem";
      # declarative.key = builtins.toPath "/etc/nixos/secret/${hostname}-syncthing-key.pem";

      declarative.devices = {
        SurfaceGo = { id = "YHAQZW5-FCLFWH3-QEUUOT2-YK7JPXE-K6ZPCYR-OXO6CYV-SJVD5UY-7YJKIAA"; };
      };

      declarative.folders = {
        "${config.users.users.alexander.home}/Sync" = {
          id = "default";
           devices = [ "SurfaceGo" ];
        };
      };
    };
}
