{
  lib,
  hosts,
  ...
}: let
  domain = "home";

  vhosts =
    lib.concatMapAttrs
    (hostName: host:
      lib.mapAttrs'
      (svcName: svc: {
        name = "${svcName}.${domain}";
        value = {
          extraConfig = ''
            reverse_proxy ${host.ip}:${toString svc.port}
          '';
        };
      })
      (host.services or {}))
    hosts;
in {
  services.caddy = {
    enable = true;

    virtualHosts = vhosts;
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
