{
  services.immich = {
    enable = true;
    port = 1212;
    openFireWall = true;
    environment.IMMICH_LOG_LEVEL = "warn";
    mediaLocation = "/foto";
  };
}
