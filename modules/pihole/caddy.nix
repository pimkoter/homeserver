{hosts, ...}: {
  services.caddy = {
    enable = true;
    httpPort = 81;
    httpsPort = 444;

    virtualHosts."pihole.home".extraConfig = ''
      reverse_proxy http://${hosts.pihole.ip}:${hosts.pihole.services.pihole}
    '';
  };
  networking.firewall.allowedTCPPorts = [80 443];
}
