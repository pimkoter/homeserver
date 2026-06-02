{
  services.immich = {
    enable = true;
    port = 2283;
    openFirewall = true;
    environment.IMMICH_LOG_LEVEL = "warn";
    mediaLocation = "/foto";
  };
}
