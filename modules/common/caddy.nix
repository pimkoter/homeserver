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
                  reverse_proxy https://${host.ip}:${toString service.port} {
                  transport http {
                    tls_insecure_skip_verify
                    }
                  }
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

    globalConfig = ''
      auto_https disable_redirects
    '';
    virtualHosts = caddyHosts;
  };
}
