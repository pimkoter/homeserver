{
  virtualisation = {
    oci-containers.backend = "docker";
    docker = {
      enable = true;
      autoPrune.enable = true;
    };
  };

  virtualisation.oci-containers = {
    containers.nextcloud-aio-mastercontainer = {
      image = "ghcr.io/nextcloud-releases/all-in-one:latest";
      autoStart = true;

      extraOptions = [
        "--init"
        "--sig-proxy=false"
      ];

      ports = [
        "80:80"
        "8080:8080"
        "8443:8443"
      ];

      volumes = [
        "nextcloud_aio_mastercontainer:/mnt/docker-aio-config"
        "/var/run/docker.sock:/var/run/docker.sock:ro"
      ];
    };
  };
}
