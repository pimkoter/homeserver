{
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  services = {
    tailscale = {
      useRoutingFeatures = "server";
    };
  };

  networking = {
    firewall = {
      allowedTCPPorts = [41641]
  };
  };
}
