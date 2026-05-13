{
  lib,
  hosts,
  ...
}: let
  domain = "home";

  caddyHosts =
    lib.foldlAttrs
    (
      acc: hostName: host:
        acc
        // (
          lib.mapAttrs'
          (
            serviceName: service:
              lib.nameValuePair "${serviceName}.${domain}" {
                extraConfig = ''
                  tls internal
                  reverse_proxy ${host.ip}:${toString service.port}
                '';
              }
          )
          (host.services or {})
        )
    )
    {}
    hosts;
in {
  services.caddy = {
    enable = true;

    virtualHosts = caddyHosts;
  };
}
