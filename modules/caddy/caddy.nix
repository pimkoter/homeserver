{
  pkgs,
  lib,
  hosts,
  ...
}: let
  hostList = lib.filterAttrs (name: value: lib.isAttrs value && value ? services) hosts;
  virtualHostsList =
    lib.mapAttrsToList (
      hostName: hostCfg:
        lib.mapAttrsToList (
          serviceName: port: let
            isProxmox = serviceName == "proxmox";
            proto =
              if isProxmox
              then "https"
              else "http";

            extraBlock =
              if isProxmox
              then ''
                transport http {
                  tls_insecure_skip_verify
                }
              ''
              else "";

            finalPort =
              if port == ""
              then "80"
              else port;
          in {
            name = "${serviceName}.${hosts.domain}";
            value = {
              extraConfig = ''
                tls internal
                reverse_proxy ${proto}://${hostCfg.ip}:${finalPort} ${
                  if isProxmox
                  then "{\n${extraBlock}}"
                  else ""
                }
              '';
            };
          }
        )
        hostCfg.services
    )
    hostList;

  virtualHosts = lib.listToAttrs (lib.flatten virtualHostsList);
in {
  services.caddy = {
    enable = true;
    inherit virtualHosts;
  };

  networking.firewall.allowedTCPPorts = [80 443];

  environment.systemPackages = with pkgs; [
    nssTools
    caddy
    p11-kit
  ];
}
