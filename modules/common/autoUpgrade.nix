{admin, ...}: {
  system.autoUpgrade = {
    enable = true;
    flake = admin.gitChannel;
    allowReboot = true;
    rebootWindow = {
      lower = "1:00";
      upper = "5:00";
    };
    flags = [
      "--print-build-logs"
      "--commit-lock-file" # If you want to automatically commit the updated flake.lock
    ];
    dates = "03:00";
    randomizedDelaySec = "1h";
  };

  nix = {
    gc = {
      automatic = true;
      dates = "6:00";
      options = "--delete-older-than 7d";
      randomizedDelaySec = "1h";
    };
    optimise = {
      automatic = true;
      dates = "7:30";
      randomizedDelaySec = "30m";
    };
  };
}
