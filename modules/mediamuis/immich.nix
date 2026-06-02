{
  services.immich = {
    enable = true;
    port = 1212;
    environment.IMMICH_LOG_LEVEL = "warn";
    mediaLocation = "/foto";
  };
}
