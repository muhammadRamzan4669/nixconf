{...}: {
  flake.nixosModules.logging = {...}: {
    services.journald.extraConfig = ''
      SystemMaxUse=500M
      SystemKeepFree=1G
      SystemMaxFileSize=50M
      MaxRetentionSec=2week
      MaxFileSec=1day
      ForwardToSyslog=no
      ForwardToKMsg=no
      ForwardToConsole=no
      ForwardToWall=yes
      Storage=persistent
      Compress=yes
      Seal=yes
      SplitMode=uid
      RateLimitIntervalSec=30s
      RateLimitBurst=10000
    '';

    systemd.coredump.enable = true;
    systemd.coredump.extraConfig = ''
      Storage=external
      Compress=yes
      ProcessSizeMax=2G
      ExternalSizeMax=2G
      JournalSizeMax=500M
      MaxUse=5G
      KeepFree=1G
    '';

    boot.kernel.sysctl = {
      "kernel.core_pattern" = "|/bin/false";
    };
  };
}
