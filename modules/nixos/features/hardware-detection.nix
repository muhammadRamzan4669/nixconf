{...}: {
  flake.nixosModules.hardware-detection = {
    config,
    lib,
    pkgs,
    ...
  }: {
    boot.initrd.availableKernelModules = lib.mkDefault [
      "xhci_pci"
      "ehci_pci"
      "ahci"
      "usbhid"
      "usb_storage"
      "sd_mod"
      "nvme"
      "sdhci_pci"
      "rtsx_pci_sdmmc"
      "mmc_block"
      "uas"
      "virtio_pci"
      "virtio_blk"
      "virtio_scsi"
    ];

    boot.kernelModules = lib.mkDefault [
      "kvm-intel"
      "kvm-amd"
    ];

    services.xserver.videoDrivers = lib.mkDefault ["modesetting"];

    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    boot.initrd.systemd.enable = lib.mkDefault true;

    services.fwupd.enable = lib.mkDefault true;

    hardware.enableRedistributableFirmware = lib.mkDefault true;
  };
}
