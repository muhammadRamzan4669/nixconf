{self, ...}: {
  flake.nixosModules.general = {
    pkgs,
    config,
    ...
  }: {
    users.users.lynx = {
      isNormalUser = true;
      description = "lynx";
      extraGroups = ["wheel" "video" "audio" "input"];
      initialPassword = "12345";
    };
  };
}
