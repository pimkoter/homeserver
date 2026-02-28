{pkgs, ...}: {
  services = {
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud33;
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
