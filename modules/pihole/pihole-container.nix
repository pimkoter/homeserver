{
  virtualisation = {
    oci-containers.containers = {
      pihole = {
        image = "pihole/pihole:2026.05.0";
        environment = {
          "TZ" = "Europe/Amsterdam";
          "FTLCONF_webserver_api_password" = "pimiseenleukejongen";
          "ServerIP" = "192.168.178.2";
        };
        volumes = [
          "/home/pim/homeserver/modules/pihole/config/pihole:/etc/pihole:rw"
        ];
        extraOptions = [
          "--network=host"
          "--cap-add=NET_ADMIN"
        ];
        log-driver = "journald";
      };
    };
  };
}
