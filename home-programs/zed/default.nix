{ config, ... }:
let
  configPath = "${config.home.homeDirectory}/nix-config/home-programs/zed";
in {
  xdg.configFile."zed/settings.json".source = 
    config.lib.file.mkOutOfStoreSymlink "${configPath}/settings.json";
}

