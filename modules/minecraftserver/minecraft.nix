{pkgs, ...}: {
  services = {
    minecraft-server = {
      enable = true;
      eula = true;

      package = pkgs.minecraft-1-21;
      dataDir = "/minecraft";
      declarative = true;

      serverProperties = {
        gamemode = "survival";
        difficulty = "hard";
        simulation-distance = 2;
      };

      whitelist = {
        # USERNAME = "UUID";
        KoterGotKicked = "b11cb5f5-6a3a-456f-980b-2d4a3a88c502";
        BramLustBoterham = "4ecf3ba8-c249-49d0-9c96-0650b52b8835";
        stronkthewarior = "e5251976-0962-4d07-aec3-5204a89af066";
        Woeps = "5b26463c-aaee-4da8-834c-017056a84800";
      };
    };
  };
}
