{
  lib,
  hosts,
  ...
}: let
  mkHosts = hostName: hostCfg:
    lib.mapAttrsToList (
      serviceName: serviceCfg:
        lib.nameValuePair "${serviceName}.${hosts.domain}" {
          extraConfig = ''
            tls internal
            reverse_proxy ${hostCfg.ip}:${toString serviceCfg.port}
          '';
        }
    ) (hostCfg.services or {});
in {
  services.caddy = {
    enable = true;

    virtualHosts = builtins.listToAttrs (
      lib.flatten (lib.mapAttrsToList mkHosts hosts)
    );
  };

  networking.firewall.allowedTCPPorts = [80 443];

  environment.etc."dnsmasq.d/99-koter.conf".text = ''
    address=/.koter/${hosts.pihole.ip}
  '';
}
