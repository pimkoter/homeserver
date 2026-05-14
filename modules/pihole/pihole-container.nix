{
  virtualisation.oci-containers.containers = {
    pihole = {
      image = "pihole/pihole:latest";
      environment = {
        "TZ" = "Europe/Amsterdam";
        "FTLCONF_webserver_api_password" = "pimiseenleukejongen";
        "FTLCONF_webserver_port" = "8080o,4043os,[::]:8080o,[::]:4043os";
      };
      volumes = [
        "/home/pim/homeserver/modules/pihole/config/pihole:/etc/pihole:rw"
      ];
      ports = [
        "8080:80/tcp"
        "67:67/udp"
      ];
      extraOptions = [
        "--network=host"
        "--cap-add=NET_ADMIN"
      ];
      log-driver = "journald";
    };
  };
}
