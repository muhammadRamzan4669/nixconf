{self, ...}: {
  flake.nixosModules.desktop = {pkgs, ...}: {

    environment.systemPackages = with pkgs; [
      kitty
      brave
      xwayland-satellite
      swaybg
      tofi
      hyprpicker
      brightnessctl
      playerctl
      btop
    ];

    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];

    fonts.fontconfig.defaultFonts = {
      monospace = ["JetBrainsMono Nerd Font Mono"];
    };

    fonts.fontconfig.antialias = true;
    fonts.fontconfig.hinting.enable = true;

    i18n.defaultLocale = "en_US.UTF-8";

    services.upower.enable = true;

    security.polkit.enable = true;

    services.logind.powerKeyLongPress = "hibernate";
    services.logind.lidSwitch = "suspend";
    services.logind.lidSwitchDocked = "ignore";

    hardware = {
      enableAllFirmware = true;

      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
  };
}
