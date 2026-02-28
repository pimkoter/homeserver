{
  services = {
    nextcloud = {
      enable = true;
      hostName = "localhost";
      appstoreEnable = true;
      config = {
        adminpassFile = "/etc/nextcloud-admin-pass";
        dbtype = "sqlite";
      };
    };
  };
  environment.etc."netxtcloud-admin-pass".text = "pimiseenleukejongen";
}
