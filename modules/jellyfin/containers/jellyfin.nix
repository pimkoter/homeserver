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
          JELLYFIN_LOG_DIR = "log";
        };
      };
    };
  };
}
