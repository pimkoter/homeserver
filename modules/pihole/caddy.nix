{hosts, ...}: {
  services.caddy = {
    enable = true;
    httpPort = 81;
    httpsPort = 444;

    virtualHosts."pihole.home".extraConfig = ''
      reverse_proxy http://${hosts.pihole.ip}
    '';
  };
  networking.firewall.allowedTCPPorts = [80 443];
}
