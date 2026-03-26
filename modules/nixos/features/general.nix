{self, ...}: {
  flake.nixosModules.general = {
    pkgs,
    config,
    lib,
    ...
  }: {
    users.users.lynx = {
      isNormalUser = true;
      description = "lynx";
      extraGroups = ["wheel" "video" "audio" "input"];
      initialHashedPassword = lib.mkDefault "";
    };

    boot.tmp.cleanOnBoot = true;
    boot.loader.systemd-boot.configurationLimit = 10;

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    nix.settings = {
      auto-optimise-store = true;
      warn-dirty = false;
      keep-outputs = false;
      keep-derivations = false;
      max-jobs = "auto";
    };

    nix.optimise = {
      automatic = true;
      dates = ["weekly"];
    };
  };
}
