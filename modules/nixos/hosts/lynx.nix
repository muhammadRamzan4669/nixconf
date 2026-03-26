{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.lynx = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostLynx
      self.nixosModules.hardwareLynx
    ];
  };

  flake.nixosModules.hostLynx = {
    pkgs,
    config,
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

    services.getty.autologinUser = "lynx";

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
    ];

    boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
    boot.initrd.kernelModules = [];
    boot.kernelModules = ["kvm-intel"];
    boot.extraModulePackages = [];

    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

    swapDevices = [];

    networking.useDHCP = lib.mkDefault true;
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
