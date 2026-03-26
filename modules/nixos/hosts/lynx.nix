{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.lynx = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.nixosModules.hostLynx
      self.nixosModules.hardwareLynx
    ];
  };

  flake.nixosModules.hostLynx = {
    pkgs,
    config,
    lib,
    ...
  }: {
    imports = [
      self.nixosModules.base
      self.nixosModules.general
      self.nixosModules.desktop
      self.nixosModules.pipewire
      self.nixosModules.nix
      self.nixosModules.extra_hjem
      self.nixosModules.network
      self.nixosModules.security
      self.nixosModules.logging
      self.nixosModules.filesystem
    ];

    boot = {
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
      kernelPackages = pkgs.linuxPackages_latest;
    };

    networking = {
      hostName = "lynx";
      useDHCP = true;
      interfaces = {};
    };

    time.timeZone = "Asia/Karachi";

    security.rtkit.enable = true;

    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    services.blueman.enable = true;


    programs.niri.enable = true;
    programs.niri.package = pkgs.niri;

    services.getty.autologinUser = lib.mkDefault "lynx";

    warnings = lib.optional (config.services.getty.autologinUser != null) ''
      WARNING: Auto-login is enabled for user '${config.services.getty.autologinUser}'.
      This provides NO authentication security. Anyone with physical access can use this system.
      This is suitable ONLY for single-user systems in physically secure locations.
      To disable auto-login, set: services.getty.autologinUser = lib.mkForce null;
    '';

    environment.loginShellInit = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
        exec niri-session
      fi
    '';

    services.interception-tools = {
      enable = true;
      plugins = [pkgs.interception-tools-plugins.caps2esc];
      udevmonConfig = ''
        - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
          DEVICE:
            EVENTS:
              EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
      '';
    };

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-wlr];
      config.common.default = ["wlr"];
    };

    hjem.users.lynx = {
      enable = true;
      directory = "/home/lynx";
      user = "lynx";
      files.".config/niri/config.kdl".source = ./lynx/niri-config.kdl;
      files.".config/kitty/kitty.conf".source = ./lynx/kitty.conf;
    };

    environment.systemPackages = with pkgs; [
      niri
      pipewire
      wireplumber
    ];

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    system.stateVersion = "24.11";
  };

  flake.nixosModules.hardwareLynx = {
    config,
    lib,
    pkgs,
    modulesPath,
    ...
  }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
      self.nixosModules.hardware-detection
    ];

    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      options = ["defaults" "noatime"];
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = ["defaults" "noatime"];
    };

    swapDevices = [];

    networking.useDHCP = lib.mkDefault true;
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}
