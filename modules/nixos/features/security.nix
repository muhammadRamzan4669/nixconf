{...}: {
  flake.nixosModules.security = {pkgs, lib, ...}: {
    security = {
      protectKernelImage = true;

      lockKernelModules = false;

      forcePageTableIsolation = true;

      apparmor = {
        enable = true;
        killUnconfinedConfinables = true;
      };

      sudo = {
        enable = true;
        wheelNeedsPassword = lib.mkDefault false;
        execWheelOnly = true;
        extraConfig = ''
          Defaults lecture = never
          Defaults timestamp_timeout=30
        '';
      };
    };

    boot.kernelParams = [
      "slab_nomerge"
      "init_on_alloc=1"
      "init_on_free=1"
      "page_alloc.shuffle=1"
      "randomize_kstack_offset=on"
      "vsyscall=none"
      "debugfs=off"
      "oops=panic"
      "quiet"
      "loglevel=3"
      "mce=0"
      "pti=on"
      "spectre_v2=on"
      "spec_store_bypass_disable=on"
      "tsx=off"
      "l1tf=full,force"
      "mds=full,nosmt"
    ];

    boot.kernel.sysctl = {
      "kernel.kptr_restrict" = 2;
      "kernel.dmesg_restrict" = 1;
      "kernel.printk" = "3 3 3 3";
      "kernel.unprivileged_bpf_disabled" = 1;
      "kernel.unprivileged_userns_clone" = 0;
      "vm.unprivileged_userfaultfd" = 0;
      "dev.tty.ldisc_autoload" = 0;
      "kernel.kexec_load_disabled" = 1;
      "kernel.sysrq" = 4;
      "net.core.bpf_jit_harden" = 2;
      "vm.mmap_rnd_bits" = 32;
      "vm.mmap_rnd_compat_bits" = 16;
      "fs.protected_symlinks" = 1;
      "fs.protected_hardlinks" = 1;
      "fs.protected_fifos" = 2;
      "fs.protected_regular" = 2;
      "fs.suid_dumpable" = 0;
    };

    boot.blacklistedKernelModules = [
      "dccp"
      "sctp"
      "rds"
      "tipc"
      "n-hdlc"
      "ax25"
      "netrom"
      "x25"
      "rose"
      "decnet"
      "econet"
      "af_802154"
      "ipx"
      "appletalk"
      "psnap"
      "p8023"
      "p8022"
      "can"
      "atm"
      "cramfs"
      "freevxfs"
      "jffs2"
      "hfs"
      "hfsplus"
      "udf"
    ];

    environment.defaultPackages = lib.mkForce [];

    programs.less.lessopen = null;

    programs.command-not-found.enable = false;

    documentation = {
      enable = true;
      doc.enable = false;
      man.enable = true;
      dev.enable = false;
      nixos.enable = false;
    };
  };
}
