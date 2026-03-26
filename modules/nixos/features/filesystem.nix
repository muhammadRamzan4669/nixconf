{...}: {
  flake.nixosModules.filesystem = {
    lib,
    config,
    ...
  }: {
    options.preferences.filesystem = {
      enableZram = lib.mkEnableOption "zram swap" // {default = true;};
      zramSize = lib.mkOption {
        type = lib.types.str;
        default = "50%";
        description = "Size of zram swap (percentage of RAM or absolute value)";
      };
    };

    config = {
      zramSwap = lib.mkIf config.preferences.filesystem.enableZram {
        enable = true;
        memoryPercent = 50;
      };

      boot.tmp.useTmpfs = lib.mkDefault false;
      boot.tmp.tmpfsSize = lib.mkDefault "50%";

      services.fstrim.enable = lib.mkDefault true;
    };
  };
}
