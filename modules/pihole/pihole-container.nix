{
  virtualisation.oci-containers.containers = {
    pihole = {
      image = "pihole/pihole:latest";
      environment = {
        "TZ" = "Europe/Amsterdam";
        "FTLCONF_webserver_api_password" = "pimiseenleukejongen";
        "ServerIP" = "192.168.178.2";
      };
      volumes = [
        "/home/pim/homeserver/modules/pihole/config/pihole:/etc/pihole:rw"
      ];
      extraOptions = [
        "--cap-add=NET_ADMIN"
        "--network=host"
      ];
      log-driver = "journald";
    };
  };
}
