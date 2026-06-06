{
  pkgs,
  lib,
  hosts,
  ...
}: let
  domain = hosts.domain or "local";

  serverHosts =
    lib.filterAttrs (
      _: value:
        lib.isAttrs value
        && value ? services
        && value ? ip
    )
    hosts;

  allServices = lib.concatLists (
    lib.mapAttrsToList (
      _: hostCfg:
        lib.mapAttrsToList (
          serviceName: port:
            assert (
              builtins.isInt port
              || builtins.isString port
              || port == null
            ); {
              inherit serviceName port;
              ip = hostCfg.ip;
            }
        )
        hostCfg.services
    )
    serverHosts
  );

  virtualHosts = lib.listToAttrs (
    map (
      service: let
        isProxmox = service.serviceName == "proxmox";

        upstreamProto =
          if isProxmox
          then "https"
          else "http";

        upstreamPort =
          if service.port == null || service.port == ""
          then "80"
          else toString service.port;

        upstream = "${upstreamProto}://${service.ip}:${upstreamPort}";
      in {
        name = "${service.serviceName}.${domain}";

        value = {
          extraConfig = ''
            reverse_proxy ${upstream}${lib.optionalString isProxmox ''
              {
                transport http {
                  tls_insecure_skip_verify
                }
              }''}
          '';
        };
      }
    )
    allServices
  );

  generatedNames =
    map (s: "${s.serviceName}.${domain}") allServices;
in {
  services.caddy = {
    enable = true;

    globalConfig = ''
      local_certs
    '';

    inherit virtualHosts;
  };

  networking.firewall.allowedTCPPorts = [80 443];

  environment.systemPackages = with pkgs; [
    caddy
    nssTools
    p11-kit
  ];

  assertions = [
    {
      assertion =
        lib.length generatedNames
        == lib.length (lib.unique generatedNames);

      message = ''
        Duplicate service names detected.

        Since hostnames are generated as:
          <service>.${domain}

        service names must be unique across all hosts.
      '';
    }
  ];
}
