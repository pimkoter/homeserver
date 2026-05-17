{
  lib,
  hosts,
  ...
}: let
  mkVirtualHost = hostName: hostCfg: let
    default =
      hostCfg.services.${hostCfg.defaultService};
  in
    lib.nameValuePair "${hostName}.koter" {
      extraConfig = ''
        tls internal
        reverse_proxy ${hostCfg.ip}:${toString default.port}
      '';
    };
in {
  services.caddy = {
    enable = true;

    virtualHosts = builtins.listToAttrs (
      lib.mapAttrsToList mkVirtualHost hosts
    );
  };

  networking.firewall.allowedTCPPorts = [80 443];

  environment.etc."dnsmasq.d/99-koter.conf".text = ''
    address=/.koter/${hosts.pihole.ip}
  '';
}
