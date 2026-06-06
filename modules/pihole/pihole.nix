{
  config,
  pkgs,
  hosts,
  ...
}: let
  lib = pkgs.lib;
  inherit (builtins) attrNames removeAttrs;

  # -----------------------------
  # Single source of truth
  # -----------------------------
  networkDomain = hosts.domain;
  baseStateDir = "/var/lib/pihole-ftl";
  certDir = "${baseStateDir}/certs";
  caDir = "${baseStateDir}/ca";
  publicCaDir = "${baseStateDir}/public-ca";
  piholeIp = hosts.pihole.ip;

  # -----------------------------
  # Host generation (safer + clearer)
  # -----------------------------
  generatePiholeHosts = hostsData: let
    hostsOnly = builtins.removeAttrs hostsData ["domain"];
  in
    lib.concatLists (
      lib.mapAttrsToList (
        hostName: hostConfig:
          assert hostConfig ? ip; let
            ip = hostConfig.ip;
            services = hostConfig.services or {};
          in
            ["${ip} ${hostName}.${networkDomain}"]
            ++ map (s: "${ip} ${s}.${networkDomain}") (attrNames services)
      )
      hostsOnly
    );

  # -----------------------------
  # Cert subject alternative names
  # -----------------------------
  certSANs = [
    "pi.${networkDomain}"
    "pihole.${networkDomain}"
    "localhost"
    "127.0.0.1"
    piholeIp
  ];
in {
  # -----------------------------
  # System packages
  # -----------------------------
  environment.systemPackages = [
    pkgs.mkcert
  ];

  # -----------------------------
  # CA trust (explicit, reproducible)
  # -----------------------------
  security.pki.certificateFiles = [
    "${publicCaDir}/rootCA.pem"
  ];

  # -----------------------------
  # Certificate generation service
  # -----------------------------
  systemd.services.generate-local-certs = {
    description = "Generate local Pi-hole TLS certificates";
    wantedBy = ["multi-user.target"];
    before = ["lighttpd.service"];

    path = [
      pkgs.mkcert
      pkgs.coreutils
      pkgs.nssTools
    ];

    script = ''
      set -euo pipefail

      export CAROOT="${caDir}"

      mkdir -p "${caDir}" "${certDir}" "${publicCaDir}"

      CA_CERT="${caDir}/rootCA.pem"
      CA_KEY="${caDir}/rootCA-key.pem"

      CERT="${certDir}/pihole.crt"
      KEY="${certDir}/pihole.key"
      COMBINED="${certDir}/pihole-combined.pem"

      # -----------------------------
      # Create CA only if missing
      # -----------------------------
      if [ ! -f "$CA_CERT" ] || [ ! -f "$CA_KEY" ]; then
        echo "Creating local mkcert CA..."
        mkcert -install
      fi

      # -----------------------------
      # Generate certificate if missing
      # -----------------------------
      if [ ! -f "$CERT" ] || [ ! -f "$KEY" ]; then
        echo "Generating Pi-hole TLS certificate..."

        mkcert \
          -cert-file "$CERT" \
          -key-file "$KEY" \
          ${lib.concatStringsSep " " certSANs}
      fi

      # -----------------------------
      # Combined PEM
      # -----------------------------
      cat "$CERT" "$KEY" > "$COMBINED"

      # -----------------------------
      # Publish CA publicly (read-only)
      # -----------------------------
      cp "$CA_CERT" "${publicCaDir}/rootCA.pem"
      chmod 644 "${publicCaDir}/rootCA.pem"

      # -----------------------------
      # Permissions (no recursive chown)
      # -----------------------------
      chown root:root "$CA_CERT" "$CA_KEY"
      chmod 600 "$CA_KEY"
      chmod 644 "$CA_CERT"

      chown lighttpd:lighttpd "$CERT" "$KEY" "$COMBINED"
      chmod 600 "$KEY" "$COMBINED"
      chmod 644 "$CERT"
    '';

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      PrivateTmp = true;
      ProtectHome = true;
      ProtectSystem = "strict";
      NoNewPrivileges = true;
    };
  };

  # -----------------------------
  # Pi-hole FTL
  # -----------------------------
  services.pihole-ftl = {
    enable = true;
    openFirewallDNS = true;
    openFirewallDHCP = true;

    settings = {
      dns = {
        upstreams = ["127.0.0.1#5335"];
        listeningMode = "all";

        domainNeeded = false;
        expandHosts = false;

        bogusPriv = true;
        queryLogging = true;

        localise = true;
        showDNSSEC = true;

        hosts = generatePiholeHosts hosts;

        revServers = [
          {
            cidr = "192.168.178.0/24";
            target = "192.168.178.10";
            domain = "${networkDomain}";
          }
        ];

        domain = {
          name = networkDomain;
          local = true;
        };

        cache = {
          size = 10000;
          optimizer = 3600;
          upstreamBlockedTTL = 86400;
          rrtype = "ANY";
        };

        blocking = {
          active = true;
          mode = "NULL";
          edns = "TEXT";
        };

        specialDomains = {
          mozillaCanary = true;
          iCloudPrivateRelay = true;
          designatedResolver = true;
        };

        rateLimit = {
          burst = 1000;
          windowSeconds = 30;
        };
      };

      dhcp = {
        active = true;
        start = "192.168.178.50";
        end = "192.168.178.254";
        router = "192.168.178.1";
        leaseTime = "6h";
        ipv6 = true;
        rapidCommit = true;
      };

      ntp = {
        ipv4.active = true;
        ipv6.active = true;

        sync = {
          active = true;
          server = "pool.ntp.org";
          interval = 3600;
          count = 8;
          rtc.utc = true;
        };
      };

      resolver = {
        resolveIPv4 = true;
        resolveIPv6 = true;
        macNames = true;
        networkNames = true;
        refreshNames = "IPV4_ONLY";
      };

      database = {
        DBimport = true;
        maxDBdays = 91;
        DBinterval = 60;
        useWAL = true;

        network = {
          parseARPcache = true;
          expire = 91;
        };
      };

      misc = {
        privacylevel = 0;
        nice = -10;
        normalizeCPU = true;

        check = {
          load = true;
          shmem = 90;
          disk = 90;
        };
      };
    };
  };

  # -----------------------------
  # Pi-hole web UI
  # -----------------------------
  services.pihole-web = {
    enable = true;
    hostName = "pihole.${networkDomain}";
    ports = ["80r" "443s"]; # 80r dwingt automatische redirect naar HTTPS af
  };

  # -----------------------------
  # Webserver SSL & Alias config
  # -----------------------------
  services.lighttpd.extraConfig = ''
    # Koppel het gecombineerde mkcert certificaat aan de HTTPS poort
    $SERVER["socket"] == ":443" {
      ssl.engine = "enable"
      ssl.pemfile = "${certDir}/pihole-combined.pem"
    }

    # Deel uitsluitend de publieke CA map via /cert
    alias.url += (
      "/cert" => "${publicCaDir}"
    )

    $HTTP["url"] =~ "^/cert" {
      mimetype.assign = (
        ".pem" => "application/x-x509-ca-cert",
        ".crt" => "application/x-x509-ca-cert"
      )
    }
  '';

  # -----------------------------
  # Lighttpd Systemd binding
  # -----------------------------
  systemd.services.lighttpd = {
    wants = ["generate-local-certs.service"];
    after = ["generate-local-certs.service"];

    # Dit is de juiste NixOS manier: herstart lighttpd als de cert-service opnieuw runt/wijzigt
    restartTriggers = [
      config.systemd.services.generate-local-certs.script
    ];
  };
}
