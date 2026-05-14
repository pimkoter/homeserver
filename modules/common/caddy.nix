{
  name,
  host,
  ...
}: {
  services.caddy = {
    enable = true;

    virtualHosts."${name}.home" = {
      extraConfig = ''
        reverse_proxy http://${host.ip}:${toString host.services.${name}.port}
      '';
    };
  };
}
