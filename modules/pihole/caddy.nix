{
  config,
  lib,
  hosts,
  ...
}: let
  inherit (lib) mapAttrsToList mkMerge;

  mkVirtualHosts = hostName: hostCfg:
    lib.mapAttrs' (
      serviceName: serviceCfg: {
        name = "${serviceName}.home";

        value = {
          extraConfig = ''
            reverse_proxy ${hostCfg.ip}:${toString serviceCfg.port}
          '';
        };
      }
    )
    (hostCfg.services or {});

  virtualHosts =
    mkMerge (mapAttrsToList mkVirtualHosts hosts);
in {
  services.caddy = {
    enable = true;
    virtualHosts = virtualHosts;
    globalConfig = ''
      auto_https off
    '';
  };
}
