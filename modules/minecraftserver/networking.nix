{lib, ...}: {
  services.resolved.enable = lib.mkForce false;
  networking = {
    useDHCP = false;
    networkmanager.enable = false;
    enableIPv6 = false;
    interfaces.ens18.ipv4.addresses = [
      {
        address = "192.168.178.8";
        prefixLength = 24;
      }
    ];
    defaultGateway = "192.168.178.1";
  };
}
