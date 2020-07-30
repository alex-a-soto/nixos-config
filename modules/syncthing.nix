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
      dataDir = "/home/alexander";

      declarative.devices = {
        SurfaceGo = { id = "YHAQZW5-FCLFWH3-QEUUOT2-YK7JPXE-K6ZPCYR-OXO6CYV-SJVD5UY-7YJKIAA"; };
	Pixel3a   = {id =  "GXHV6JT-W7X47B7-TMNTAXA-ZF4X6DK-R3X37D6-CKRYPRP-BSPYP4K-45TU6QK"; };
      };

      declarative.folders = {
        "${config.users.users.alexander.home}/1-Agenda" = {
          id = "1-Agenda";
          devices = [ "SurfaceGo"];
	  label = "1-Agenda";
	  type = "sendonly";
          versioning = { params = {
	    cleanInterval = "3600";
	    maxAge = "31536000";
	    versionsPath = "${config.users.users.alexander.home}/3-Non"; };
	    type = "staggered"; };
        };
	  "${config.users.users.alexander.home}/2-Linked/3-Persinter/1-persinter" = {
          id = "Persinter";
          devices = [ "Pixel3a"];
	  label = "Persinter";
	  type = "sendonly";
          versioning = { params = {
	    cleanInterval = "3600";
	    maxAge = "31536000";
	    versionsPath = "${config.users.users.alexander.home}/3-Non"; };
	    type = "staggered"; };
        };
	"${config.users.users.alexander.home}/2-Linked" = {
          id = "2-Linked";
          devices = [ "SurfaceGo"];
	  label = "2-Linked";
	  type = "sendonly";
          versioning = { params = {
	    cleanInterval = "3600";
	    maxAge = "31536000";
	    versionsPath = "${config.users.users.alexander.home}/3-Non"; };
	    type = "staggered"; };
        };
      };
   };
}


