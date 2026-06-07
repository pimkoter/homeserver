{
  description = "Koter's original love";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {nixpkgs, ...}: let
    defaultSystem = "x86_64-linux";
    admin = {
      name = "pim";
      pswd = "$6$VrOHvIFjn6HTuxUz$5gp2v0XFmRRx4eOv.X1EDiPXGyUD/OKYVByhUK609iuIZsxzW9l0fkbxmo9w1SNCzxbSD0DAj0gUeNQOSQwJX/";
      flakeDir = "/home/${admin.name}/homeserver";
      gitChannel = "github:pimkoter/homeserver";
    };

    hosts = {
      domain = "puber";
      piHole = {
        ip = "192.168.178.2";
        services = {
          piHole = "80";
        };
      };
      mediaMuis = {
        ip = "192.168.178.4";
        services = {
          jellyFin = "8096";
          seerr = "5055";
          bazarr = "6767";
          radarr = "7878";
          sonarr = "8989";
          qBitTorrent = "8080";
          prowlarr = "9696";
          immich = "2283";
        };
      };
      caddy = {
        ip = "192.168.178.8";
      };
      exitNode = {
        ip = "192.168.178.9";
      };
      proxMox = {
        ip = "192.168.178.10";
        services = {
          proxMox = "8006";
        };
      };
      dataDodo = {
        ip = "192.168.178.3";
        services = {
          vaultWarden = "8222";
          forgeJo = "";
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
