{
  # Containers
  virtualisation = {
    oci-containers.containers = {
      "jellyfin" = {
        image = "jellyfin/jellyfin";
        autoStart = true;

        volumes = [
          "/cache/jellyfin:/cache:rw"
          "/config/jellyfin:/config:rw"
          "/media/movies:/media/movies:ro"
          "/media/shows:/media/tv:ro"
        ];
        ports = [
          "8096:8096/tcp"
          "7359:7359/udp"
        ];
        user = "1000:1000";
        log-driver = "journald";
        extraOptions = [
          "--network-alias=jellyfin"
          "--network=jellyfin"
        ];
      };
    };
  };
}
