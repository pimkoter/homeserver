{
  description = "Koter's original love";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {nixpkgs, ...}: let
    defaultSystem = "x86_64-linux";
    admin = "pim";

    hosts = {
      domain = "puber";
      pihole = {
        ip = "192.168.178.2";
        services = {
          pihole = "80";
        };
      };
      jellyfin = {
        ip = "192.168.178.4";
        services = {
          jellyfin = "8096";
          jellyseerr = "5055";
          bazarr = "6767";
          radarr = "7878";
          sonarr = "8989";
          qbittorrent = "8080";
          prowlarr = "9696";
        };
      };
      caddy = {
        ip = "192.168.178.8";
      };
      exitnode = {
        ip = "192.168.178.9";
      };
      proxmox = {
        ip = "192.168.178.10";
        services = {
          proxmox = "8006";
        };
      };
    };
    mkHost = name:
      nixpkgs.lib.nixosSystem {
        system = defaultSystem;

        specialArgs = {
          inherit name admin hosts;
          host = hosts.${name};
        };

        modules = [
          ./modules/common/default.nix
          ./modules/${name}/default.nix
        ];
      };
  in {
    nixosConfigurations =
      nixpkgs.lib.mapAttrs (name: _: mkHost name) hosts;
  };
}
