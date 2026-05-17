{hosts, ...}: {
  services.caddy = {
    enable = true;
    httpPort = 81;
    httpsPort = 444;

    globalConfig = ''
      auto_https off
    '';

    virtualHosts."pihole.home".extraConfig = ''
      tls internal
      reverse_proxy http://${hosts.pihole.ip}:${hosts.pihole.services.pihole}
    '';
  };
  networking.firewall.allowedTCPPorts = [81 444];
}
