{...}: {
  flake.nixosModules.systemd-hardening = {lib, ...}: {
    systemd.services = let
      hardenService = {
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        NoNewPrivileges = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictAddressFamilies = ["AF_INET" "AF_INET6" "AF_UNIX"];
        RestrictNamespaces = true;
        SystemCallArchitectures = "native";
        PrivateUsers = true;
      };
    in {
      systemd-resolved.serviceConfig = hardenService // {
        ProtectHome = lib.mkForce false;
        PrivateDevices = lib.mkForce false;
      };

      systemd-timesyncd.serviceConfig = hardenService // {
        ProtectHome = lib.mkForce false;
      };
    };

    systemd.user.services = {};
  };
}
