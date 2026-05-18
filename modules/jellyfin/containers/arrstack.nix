let
  configDir = "/config";
  mediaDir = "/media";
  network = "arrstack";
  PUID = "1000";
  PGID = "1000";

  # Shared environment for all containers
  baseEnv = {
    LOG_LEVEL = "debug";
    TZ = "Europe/Amsterdam";
    PUID = PUID;
    PGID = PGID;
  };
in {
  virtualisation.oci-containers = {
    containers = {
      prowlarr = {
        image = "lscr.io/linuxserver/prowlarr:latest";
        autoStart = true;
        ports = ["9696:9696/tcp"];
        volumes = [
          {
            hostPath = "${configDir}/prowlarr";
            containerPath = "/config";
            ignoreMissing = true;
          }
        ];
        environment = baseEnv;
        networks = [network];
      };

      radarr = {
        image = "lscr.io/linuxserver/radarr:latest";
        autoStart = true;
        ports = ["7878:7878/tcp"];
        volumes = [
          {
            hostPath = "${configDir}/radarr";
            containerPath = "/config";
            ignoreMissing = true;
          }
          {
            hostPath = "${mediaDir}/movies";
            containerPath = "/movies";
            ignoreMissing = true;
          }
          {
            hostPath = "${mediaDir}/downloads";
            containerPath = "/downloads";
            ignoreMissing = true;
          }
        ];
        environment = baseEnv;
        networks = [network];
      };

      sonarr = {
        image = "lscr.io/linuxserver/sonarr:latest";
        autoStart = true;
        ports = ["8989:8989/tcp"];
        volumes = [
          {
            hostPath = "${configDir}/sonarr";
            containerPath = "/config";
            ignoreMissing = true;
          }
          {
            hostPath = "${mediaDir}/shows";
            containerPath = "/tv";
            ignoreMissing = true;
          }
          {
            hostPath = "${mediaDir}/downloads";
            containerPath = "/downloads";
            ignoreMissing = true;
          }
        ];
        environment = baseEnv;
        networks = [network];
      };

      qbittorrent = {
        image = "lscr.io/linuxserver/qbittorrent:latest";
        autoStart = true;
        ports = ["8080:8080/tcp"];
        volumes = [
          {
            hostPath = "${configDir}/qbittorrent";
            containerPath = "/config";
            ignoreMissing = true;
          }
          {
            hostPath = "${mediaDir}/downloads";
            containerPath = "/downloads";
            ignoreMissing = true;
          }
          {
            hostPath = "${mediaDir}/movies";
            containerPath = "/movies";
            ignoreMissing = true;
          }
          {
            hostPath = "${mediaDir}/shows";
            containerPath = "/shows";
            ignoreMissing = true;
          }
        ];
        environment = baseEnv;
        networks = [network];
      };

      bazarr = {
        image = "lscr.io/linuxserver/bazarr:latest";
        autoStart = true;
        ports = ["6767:6767/tcp"];
        volumes = [
          {
            hostPath = "${configDir}/bazarr";
            containerPath = "/config";
            ignoreMissing = true;
          }
          {
            hostPath = "${mediaDir}/movies";
            containerPath = "/movies";
            ignoreMissing = true;
          }
          {
            hostPath = "${mediaDir}/shows";
            containerPath = "/tv";
            ignoreMissing = true;
          }
        ];
        environment = baseEnv;
        networks = [network];
      };

      seerr = {
        image = "ghcr.io/seerr-team/seerr:latest";
        autoStart = true;
        ports = ["5055:5055/tcp"];
        volumes = [
          {
            hostPath = "${configDir}/seerr";
            containerPath = "/app/config";
            ignoreMissing = true;
          }
        ];
        environment = baseEnv;
        networks = [network];
      };
    };
  };
}
