{self, ...}: {
  flake.nixosModules.desktop = {pkgs, ...}: {
    imports = [
      self.nixosModules.wallpaper
    ];

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

    i18n.defaultLocale = "en_US.UTF-8";

    services.upower.enable = true;

    security.polkit.enable = true;

    hardware = {
      enableAllFirmware = true;

      opengl = {
        enable = true;
        driSupport32Bit = true;
      };
    };
  };
}
