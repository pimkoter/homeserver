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
      ports = [
        "8080:80/tcp"
        "67:67/udp"
        "53:53/tcp"
        "53:53/udp"
        "8443:443/udp"
      ];
      extraOptions = [
        "--cap-add=NET_ADMIN"
      ];
      log-driver = "journald";
    };
  };
}
