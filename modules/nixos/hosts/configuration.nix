{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.lynx = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostLynx
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
      self.nixosModules.hardwareLynx
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

    services.timesyncd.enable = true;

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

    system.stateVersion = "25.05";
  };
}
