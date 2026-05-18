{
  # Containers
  virtualisation = {
    oci-containers.containers = {
      "jellyfin" = {
        image = "jellyfin/jellyfin";
        autoStart = true;

        volumes = [
          "/logs/jellyfin:/log"
          "/cache/jellyfin:/cache"
          "/config/jellyfin:/config"
          "/media/movies:/movies"
          "/media/shows:/tv"
        ];
        ports = [
          "8096:8096/tcp"
        ];
        environment = {
          LOG_LEVEL = "debug";
          TZ = "Europe/Amsterdam";
        };
      };
    };
  };
}
