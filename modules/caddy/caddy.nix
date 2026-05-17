{
  pkgs,
  hosts,
  ...
}: {
  services.caddy = {
    enable = true;
    globalConfig = ''
      auto_https off
    '';

    virtualHosts = {
      "pihole.${hosts.domain}".extraConfig = ''
        tls internal
        reverse_proxy http://${hosts.pihole.ip}:${hosts.pihole.services.pihole}
      '';

      "jellyfin.${hosts.domain}".extraConfig = ''
        tls internal
        reverse_proxy http://${hosts.jellyfin.ip}:${hosts.jellyfin.services.jellyfin}
      '';
    };
  };
  networking.firewall.allowedTCPPorts = [80 443];

  environment.systemPackages = with pkgs; [
    nssTools
  ];
}
