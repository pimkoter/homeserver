{pkgs, ...}: {
  services = {
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud33;
      hostName = "192.168.178.3";
      appstoreEnable = true;
      config = {
        adminpassFile = "/etc/nextcloud-admin-pass";
        dbtype = "sqlite";
      };
      datadir = "/nextcloud";
      settings.trusted_domains = ["192.168.178.3" "tailscale0"];
    };
  };
  environment.etc."nextcloud-admin-pass".text = "pimiseenleukejongen";
}
