{
  pkgs,
  hosts,
  ...
}: {
  services.caddy = {
    enable = true;
    virtualHosts = {
      "pihole.${hosts.domain}".extraConfig = ''
        tls internal
        reverse_proxy http://${hosts.pihole.ip}:${hosts.pihole.services.pihole}
      '';

      "jellyfin.${hosts.domain}".extraConfig = ''
        tls internal
        reverse_proxy http://${hosts.mediamuis.ip}:${hosts.mediamuis.services.jellyfin}
      '';

      "bazarr.${hosts.domain}".extraConfig = ''
        tls internal
        reverse_proxy http://${hosts.mediamuis.ip}:${hosts.mediamuis.services.bazarr}
      '';

      "seerr.${hosts.domain}".extraConfig = ''
        tls internal
        reverse_proxy http://${hosts.mediamuis.ip}:${hosts.mediamuis.services.seerr}
      '';

      "qbittorrent.${hosts.domain}".extraConfig = ''
        tls internal
        reverse_proxy http://${hosts.mediamuis.ip}:${hosts.mediamuis.services.qbittorrent}
      '';

      "radarr.${hosts.domain}".extraConfig = ''
        tls internal
        reverse_proxy http://${hosts.mediamuis.ip}:${hosts.mediamuis.services.radarr}
      '';

      "sonarr.${hosts.domain}".extraConfig = ''
        tls internal
        reverse_proxy http://${hosts.mediamuis.ip}:${hosts.mediamuis.services.sonarr}
      '';

      "prowlarr.${hosts.domain}".extraConfig = ''
        tls internal
        reverse_proxy http://${hosts.mediamuis.ip}:${hosts.mediamuis.services.prowlarr}
      '';

      "proxmox.${hosts.domain}".extraConfig = ''
        tls internal
        reverse_proxy https://${hosts.proxmox.ip}:${hosts.proxmox.services.proxmox} {
          transport http {
            tls_insecure_skip_verify
          }
        }
      '';
    };
  };
  networking.firewall.allowedTCPPorts = [80 443];

  environment.systemPackages = with pkgs; [
    nssTools
    caddy
    p11-kit
  ];
}
