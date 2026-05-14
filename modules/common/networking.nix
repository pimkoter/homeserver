{
  lib,
  name,
  host,
  hosts,
  ...
}: let
  network = {
    iface = "ens18";
    gateway = "192.168.178.1";
    prefixLength = 24;
    domain = "home";
  };
in {
  services = {
    resolved.enable = lib.mkForce false;
    tailscale = {
      enable = true;
    };
  };

  networking = {
    useDHCP = false;
    nameservers = [
      hosts.pihole.ip
    ];

    networkmanager.enable = false;

    hostName = name;
    domain = network.domain;

    interfaces.${network.iface}.ipv4.addresses = [
      {
        address = host.ip;
        prefixLength = 24;
      }
    ];

    defaultGateway = network.gateway;

    firewall = {
      enable = true;
      trustedInterfaces = ["ens18" "tailscale0" "80" "443"];
    };
  };

  security.pki.certificateFiles = [
    "/etc/ssl/certs/caddy-root.crt"
  ];
}
