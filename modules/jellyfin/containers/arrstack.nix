{
  # Containers
  virtualisation = {
    oci-containers.containers = {
      "prowlarr" = {
        image = "prowlarr/prowlarr";
        autoStart = true;

        volumes = [
          "/config/prowlarr:/config"
        ];
        ports = [
          "9696:9696/tcp"
        ];
      };

      "radarr" = {
        image = "radarr/radarr";
        autoStart = true;

        volumes = [
          "/config/radarr:/config"
          "/media/movies:/movies"
          "/media/downloads:/downloads"
        ];
        ports = [
          "7878:7878/tcp"
        ];
      };

      "sonarr" = {
        image = "sonarr/sonarr";
        autoStart = true;

        volumes = [
          "/config/sonarr:/config"
          "/media/shows:/tv"
          "/media/downloads:/downloads"
        ];
        ports = [
          "8989:8989/tcp"
        ];
      };

      "qbittorrent" = {
        image = "qbittorrent/qbittorrent";
        autoStart = true;

        volumes = [
          "/config/qbittorrent:/config"
          "/media/downloads:/downloads"
        ];
        ports = [
          "8080:8080/tcp"
        ];
      };

      "bazarr" = {
        image = "bazarr/bazarr";
        autoStart = true;

        volumes = [
          "/config/bazarr:/config"
          "/media/movies:/movies"
          "/media/shows:/tv"
        ];
        ports = [
          "6767:6767/tcp"
        ];
      };

      "jellyseerr" = {
        image = "jellyseerr/jellyseerr";
        autoStart = true;

        volumes = [
          "/config/jellyseerr:/config"
        ];
        ports = [
          "5055:5055/tcp"
        ];
      };
    };
  };
}
