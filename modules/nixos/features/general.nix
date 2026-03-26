{self, ...}: {
  flake.nixosModules.general = {
    pkgs,
    config,
    ...
  }: {
    users.users.lynx = {
      isNormalUser = true;
      description = "lynx";
      extraGroups = ["wheel" "video" "audio" "input"];
      initialHashedPassword = "";
    };

    security.sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };

    boot.tmp.cleanOnBoot = true;
    boot.loader.systemd-boot.configurationLimit = 10;

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    nix.settings.auto-optimise-store = true;
  };
}
