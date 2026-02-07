{lib, ...}: {
  services.resolved.enable = lib.mkForce false;
  networking = {
    useDHCP = false;
    networkmanager.enable = false;

    interfaces.ens18.ipv4.addresses = [
      {
        address = "192.168.178.4";
        prefixLength = 24;
      }
    ];
    defaultGateway = "192.168.178.1";
    firewall = {
      enable = true;
      trustedInterfaces = ["ens18"];
    };
  };
}
