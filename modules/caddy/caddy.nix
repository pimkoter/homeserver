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
        reverse_proxy http://${hosts.pihole.ip}:${hosts.pihole.services.pihole}
      '';

      "jellyfin.${hosts.domain}".extraConfig = ''
        reverse_proxy http://${hosts.jellyfin.ip}:${hosts.jellyfin.services.jellyfin}
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
