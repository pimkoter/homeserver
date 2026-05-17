{
  description = "Koter's original love";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    defaultSystem = "x86_64-linux";
    admin = "pim";

    hosts = {
      domain = "koter";
      pihole = {
        ip = "192.168.178.2";
        services = {
          pihole = {port = 8080;};
        };
      };
      jellyfin = {
        ip = "192.168.178.4";
        services = {
          jellyfin = {port = 8096;};
          prowlarr = {port = 8989;};
        };
      };
      exitnode = {
        ip = "192.168.178.9";
      };
      proxmox = {
        ip = "192.168.178.10";
        services = {
          proxmox = {port = 8006;};
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
