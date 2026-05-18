{
  pkgs,
  hosts,
  ...
}: {
  services.caddy = {
    enable = true;
    globalConfig = ''
    '';

    virtualHosts = {
      "pihole.${hosts.domain}".extraConfig = ''
        tls internal
        reverse_proxy http://${hosts.pihole.ip}:${hosts.pihole.services.pihole}/admin
      '';

      "jellyfin.${hosts.domain}".extraConfig = ''
        tls internal
        reverse_proxy http://${hosts.jellyfin.ip}:${hosts.jellyfin.services.jellyfin}
      '';

      "bazarr.${hosts.domain}".extraConfig = ''
        tls internal
        reverse_proxy http://${hosts.jellyfin.ip}:${hosts.jellyfin.services.bazarr}
      '';

     "jellyseerr.${hosts.domain}".extraConfig = ''
        tls internal
        reverse_proxy http://${hosts.jellyfin.ip}:${hosts.jellyfin.services.jellyseerr}
      '';

      "qbittorrent.${hosts.domain}".extraConfig = ''
        tls internal
        reverse_proxy http://${hosts.jellyfin.ip}:${hosts.jellyfin.services.qbittorrent}
      '';
   
     "radarr.${hosts.domain}".extraConfig = ''
        tls internal
        reverse_proxy http://${hosts.jellyfin.ip}:${hosts.jellyfin.services.radarr}
      '';
  
     "sonarr.${hosts.domain}".extraConfig = ''
        tls internal
        reverse_proxy http://${hosts.jellyfin.ip}:${hosts.jellyfin.services.sonarr}
      '';
  
      "prowlarr.${hosts.domain}".extraConfig = ''
        tls internal
        reverse_proxy http://${hosts.jellyfin.ip}:${hosts.jellyfin.services.prowlarr}
      '';



      proxmox.${hosts.domain}".extraConfig = ''
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
