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
      self.nixosModules.extra_hjem
    ];

    boot = {
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
      kernelPackages = pkgs.linuxPackages_latest;
    };

    networking = {
      hostName = "lynx";
      wireless.enable = true;
      wireless.userControlled.enable = true;
    };

    time.timeZone = "Asia/Karachi";

    users.users.lynx = {
      isNormalUser = true;
      description = "lynx";
      extraGroups = ["wheel" "video" "audio" "input"];
      initialPassword = "12345";
    };

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

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

    environment.systemPackages = with pkgs; [
      niri
      kitty
      brave
      xwayland-satellite
      swaybg
      tofi
      hyprpicker
      brightnessctl
      playerctl
      pipewire
      wireplumber
      nerd-fonts.jetbrains-mono
      wpa_supplicant_gui
      btop
    ];

    hjem.users.lynx = {
      enable = true;
      directory = "/home/lynx";
      user = "lynx";
      files.".config/niri/config.kdl".source = ./niri-config.kdl;
      files.".config/kitty/kitty.conf".source = ./kitty.conf;
    };

    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = ["nix-command" "flakes"];

    system.stateVersion = "25.05";
  };
}
