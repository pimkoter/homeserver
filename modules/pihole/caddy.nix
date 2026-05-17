{
  lib,
  hosts,
  ...
}: let
  services = lib.flatten (
    lib.mapAttrsToList (
      _hostName: host:
        lib.mapAttrsToList (
          svcName: svc: {
            name = svcName;
            target = "${host.ip}:${toString svc.port}";
          }
        )
        host.services
    )
    hosts
  );
in {
  services.caddy = {
    enable = true;

    virtualHosts = lib.listToAttrs (map (svc: {
        name = "${svc.name}.${hosts.domain}";
        value = {
          extraConfig = ''
            reverse_proxy ${svc.target}
          '';
        };
      })
      services);
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
