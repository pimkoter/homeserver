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
      "pihole.${hosts.domain}.arpa".extraConfig = ''
        tls internal
        reverse_proxy http://${hosts.pihole.ip}:${hosts.pihole.services.pihole}
      '';

      "jellyfin.${hosts.domain}.arpa".extraConfig = ''
        tls internal
        reverse_proxy http://${hosts.jellyfin.ip}:${hosts.jellyfin.services.jellyfin}
      '';

      "proxmox.${hosts.domain}.arpa".extraConfig = ''
        tls internal
        reverse_proxy http://${hosts.proxmox.ip}:${hosts.proxmox.services.proxmox}
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
