let
  configDir = /config;
  mediaDir = /media;
  network = "arrstack";
  PUID = "1000";
  PGID = "1000";
in {
  # Containers
  virtualisation = {
    oci-containers = {
      networks = {
        ${network} = {
          type = "bridge";
        };
      };
      containers = {
        "prowlarr" = {
          image = "lscr.io/linuxserver/prowlarr:latest";
          autoStart = true;

          volumes = [
            "${configDir}/prowlarr:/config"
          ];
          ports = [
            "9696:9696/tcp"
          ];
          environment = {
            LOG_LEVEL = "debug";
            TZ = "Europe/Amsterdam";
            PUID = PUID;
            PGID = PGID;
          };
          networks = [network];
        };

        "radarr" = {
          image = "lscr.io/linuxserver/radarr:latest";
          autoStart = true;

          volumes = [
            "${configDir}/radarr:/config"
            "${mediaDir}/movies:/movies"
            "${mediaDir}/downloads:/downloads"
          ];
          ports = [
            "7878:7878/tcp"
          ];
          environment = {
            LOG_LEVEL = "debug";
            TZ = "Europe/Amsterdam";
            PUID = PUID;
            PGID = PGID;
          };
          networks = [network];
        };

        "sonarr" = {
          image = "lscr.io/linuxserver/sonarr:latest";
          autoStart = true;

          volumes = [
            "${configDir}/sonarr:/config"
            "${mediaDir}/shows:/tv"
            "/media/downloads:/downloads"
          ];
          ports = [
            "8989:8989/tcp"
          ];
          environment = {
            LOG_LEVEL = "debug";
            TZ = "Europe/Amsterdam";
            PUID = PUID;
            PGID = PGID;
          };
          networks = [network];
        };

        "qbittorrent" = {
          image = "lscr.io/linuxserver/qbittorrent:latest";
          autoStart = true;

          volumes = [
            "${configDir}/qbittorrent:/config"
            "${mediaDir}/downloads:/downloads"
            "${mediaDir}/movies:/movies"
            "${mediaDir}/shows:/shows"
          ];
          ports = [
            "8080:8080/tcp"
          ];
          environment = {
            LOG_LEVEL = "debug";
            TZ = "Europe/Amsterdam";
            PUID = PUID;
            PGID = PGID;
          };
          networks = [network];
        };

        "bazarr" = {
          image = "lscr.io/linuxserver/bazarr:latest";
          autoStart = true;

          volumes = [
            "${configDir}/bazarr:/config"
            "${mediaDir}/movies:/movies"
            "${mediaDir}/shows:/tv"
          ];
          ports = [
            "6767:6767/tcp"
          ];
          environment = {
            LOG_LEVEL = "debug";
            TZ = "Europe/Amsterdam";
            PUID = PUID;
            PGID = PGID;
          };
          networks = [network];
        };

        "seerr" = {
          image = "ghcr.io/seerr-team/seerr:latest";
          autoStart = true;

          volumes = [
            "${configDir}/seerr:/app/config"
          ];
          ports = [
            "5055:5055/tcp"
          ];
          environment = {
            LOG_LEVEL = "debug";
            TZ = "Europe/Amsterdam";
            PUID = PUID;
            PGID = PGID;
          };
          networks = [network];
        };
      };
    };
  };
}
