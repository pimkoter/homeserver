{
  services.unbound = {
    enable = true;
    settings = {
      interface = ["127.0.0.1" "192.168.178.2"];
      port = "5335";
      prefetch = "yes";
    };
  };
}
