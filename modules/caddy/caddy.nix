{hosts, ...}: {
  services.caddy = {
    enable = true;
    globalConfig = ''
      auto_https off
    '';

    virtualHosts = {
      "pihole.home".extraConfig = ''
        tls internal
        reverse_proxy http://${hosts.pihole.ip}:${hosts.pihole.services.pihole}
      '';

      "jellyfin.home".extraConfig = ''
        tls internal
        reverse_proxy http://${hosts.jellyfin.ip}:${hosts.jellyfin.services.jellyfin}
      '';
    };
  };
  networking.firewall.allowedTCPPorts = [81 444];
}
