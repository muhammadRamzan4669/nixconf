{...}: {
  flake.nixosModules.nix = {lib, ...}: {
    nix.settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["@wheel"];
      allowed-users = ["@wheel"];
      sandbox = true;
      extra-sandbox-paths = [];
      restrict-eval = false;
      allow-import-from-derivation = true;
    };

    nixpkgs.config = {
      allowUnfree = true;
      allowBroken = false;
      permittedInsecurePackages = [];
    };

    nix.extraOptions = ''
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
    '';
  };
}
