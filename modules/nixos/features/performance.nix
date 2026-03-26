{...}: {
  flake.nixosModules.performance = {lib, pkgs, ...}: {
    boot.kernel.sysctl = {
      "vm.swappiness" = lib.mkDefault 10;
      "vm.vfs_cache_pressure" = lib.mkDefault 50;
      "vm.dirty_ratio" = lib.mkDefault 10;
      "vm.dirty_background_ratio" = lib.mkDefault 5;
      "kernel.nmi_watchdog" = lib.mkDefault 0;
    };

    powerManagement = {
      enable = lib.mkDefault true;
      cpuFreqGovernor = lib.mkDefault "schedutil";
    };

    services.irqbalance.enable = lib.mkDefault true;

    systemd.extraConfig = ''
      DefaultTimeoutStopSec=10s
      DefaultTimeoutStartSec=30s
    '';
  };
}
