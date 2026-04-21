{
  # Containers
  virtualisation = {
    oci-containers.containers = {
      "prowlarr" = {
        image = "lscr.io/linuxserver/prowlarr:latest";
        autoStart = true;

        volumes = [
          "/config/prowlarr:/config"
        ];
        ports = [
          "9696:9696/tcp"
        ];
        environment = {
          LOG_LEVEL = "debug";
          TZ = "Europe/Amsterdam";
        };
      };

      "radarr" = {
        image = "lscr.io/linuxserver/radarr:latest";
        autoStart = true;

        volumes = [
          "/config/radarr:/config"
          "/media/movies:/movies"
          "/media/downloads:/downloads"
        ];
        ports = [
          "7878:7878/tcp"
        ];
        environment = {
          LOG_LEVEL = "debug";
          TZ = "Europe/Amsterdam";
        };
      };

      "sonarr" = {
        image = "lscr.io/linuxserver/sonarr:latest";
        autoStart = true;

        volumes = [
          "/config/sonarr:/config"
          "/media/shows:/tv"
          "/media/downloads:/downloads"
        ];
        ports = [
          "8989:8989/tcp"
        ];
        environment = {
          LOG_LEVEL = "debug";
          TZ = "Europe/Amsterdam";
        };
      };

      "qbittorrent" = {
        image = "lscr.io/linuxserver/qbittorrent:latest";
        autoStart = true;

        volumes = [
          "/config/qbittorrent:/config"
          "/media/downloads:/downloads"
        ];
        ports = [
          "8080:8080/tcp"
        ];
        environment = {
          LOG_LEVEL = "debug";
          TZ = "Europe/Amsterdam";
        };
      };

      "bazarr" = {
        image = "lscr.io/linuxserver/bazarr:latest";
        autoStart = true;

        volumes = [
          "/config/bazarr:/config"
          "/media/movies:/movies"
          "/media/shows:/tv"
        ];
        ports = [
          "6767:6767/tcp"
        ];
        environment = {
          LOG_LEVEL = "debug";
          TZ = "Europe/Amsterdam";
        };
      };

      "seerr" = {
        image = "ghcr.io/seerr-team/seerr:latest";
        autoStart = true;

        volumes = [
          "/config/seerr:/config"
        ];
        ports = [
          "5055:5055/tcp"
        ];
        environment = {
          LOG_LEVEL = "debug";
          TZ = "Europe/Amsterdam";
        };
      };
    };
  };
}
