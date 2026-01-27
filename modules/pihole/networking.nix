{lib, ...}: {
  services.resolved.enable = lib.mkForce false;
  networking = {
    useDHCP = false;
    networkmanager.enable = false;

    interfaces.ens18.ipv4.addresses = [
      {
        address = "192.168.178.2";
        prefixLength = 24;
      }
    ];
    defaultGateway = "192.168.178.1";
    nameservers = ["1.1.1.1"];
    firewall = {
      enable = true;
      trustedInterfaces = ["ens18"];
      allowedTCPPorts = [53 80 443 5335];
      allowedUDPPorts = [53 67 80 5335];
    };
  };
}
