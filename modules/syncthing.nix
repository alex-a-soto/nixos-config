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
        SurfaceGo = { id = "ZDOI3RT-K47RMA2-6AXHUW2-A2BLE6V-KZ5MK4N-33WFZK5-EQRARBE-FRSHQAL"; };
#	Pixel3a   = {id =  "GXHV6JT-W7X47B7-TMNTAXA-ZF4X6DK-R3X37D6-CKRYPRP-BSPYP4K-45TU6QK"; };
      };

      declarative.folders = {
        "${config.users.users.alexander.home}/Vault/1-Personal" = {
          id = "1-Personal";
          devices = [ "SurfaceGo"];
	  label = "1-Personal";
	  type = "sendonly";
          versioning = { params = {
	    cleanInterval = "3600";
	    maxAge = "31536000";
#	    versionsPath = "${config.users.users.alexander.home}/1-Personal/3-Non";
};
	    type = "staggered"; };
        };

        "${config.users.users.alexander.home}/Vault/2-Work" = {
          id = "2-Work";
          devices = [ "SurfaceGo"];
	  label = "2-Work";
	  type = "sendonly";
          versioning = { params = {
	    cleanInterval = "3600";
	    maxAge = "31536000";
#	    versionsPath = "${config.users.users.alexander.home}/1-Personal/3-Non";
};
	    type = "staggered"; };
        };

        "${config.users.users.alexander.home}/Vault/HUD" = {
          id = "HUD";
          devices = [ "SurfaceGo"];
	  label = "HUD";
	  type = "sendonly";
          versioning = { params = {
	    cleanInterval = "3600";
	    maxAge = "31536000";
#	    versionsPath = "${config.users.users.alexander.home}/1-Personal/3-Non";
};
	    type = "staggered"; };
        };
   };
};
}
