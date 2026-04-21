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
          "/media/movies:/media/movies"
          "/media/shows:/media/tv"
        ];
        ports = [
          "8096:8096/tcp"
          "7359:7359/udp"
        ];
        user = "1000:1000";
        log-driver = "journald";
        #        environment = {
        #          JELLYFIN_LOG_DIR = "log";
        #        };
        extraOptions = [
          "--network-alias=jellyfin"
          "--network=jellyfin"
        ];
      };
    };
  };
}
