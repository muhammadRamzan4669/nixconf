{
  flake.nixosModules.wallpaper = {pkgs, ...}: {
    preferences.autostart = [
      ''${pkgs.swaybg}/bin/swaybg -i $HOME/wallpaper.png &''
    ];
  };
}
