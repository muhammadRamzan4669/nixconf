{inputs, ...}: {
  flake.nixosModules.extra_hjem = {...}: {
    imports = [
      inputs.hjem.nixosModules.default
    ];

    hjem = {
      clobberByDefault = true;
    };
  };
}
