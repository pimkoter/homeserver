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
  services.resolved.enable = lib.mkForce false;

  networking = {
    useDHCP = false;
    nameservers = [
      hosts.pihole.ip
      "1.1.1.1"
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
      trustedInterfaces = ["ens18"];
    };
  };
}
