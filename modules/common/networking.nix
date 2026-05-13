{
  lib,
  name,
  host,
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
    networkmanager.enable = false;

    hostName = name;
    domain = "home";

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
