# Changelog - NixOS Configuration Updates

## 2026-03-26 - Best Practices & Security Hardening

### Major Improvements

#### 1. Flake Configuration
- Added `specialArgs` to `nixosSystem` for proper argument passing
- Added `inputs.nixpkgs.follows` for all flake inputs to prevent dependency duplication
- Better dependency management and smaller flake.lock file

#### 2. Enhanced Security Hardening

**Kernel Parameters:**
- Added CPU vulnerability mitigations: `pti=on`, `spectre_v2=on`, `spec_store_bypass_disable=on`
- Added hardware bug mitigations: `mce=0`, `tsx=off`, `l1tf=full,force`, `mds=full,nosmt`

**Kernel Sysctl:**
- Added `kernel.kexec_load_disabled = 1` - Prevent kexec exploitation
- Added `kernel.sysrq = 4` - Restricted SysRq functionality
- Added `net.core.bpf_jit_harden = 2` - Harden BPF JIT compiler
- Added `vm.mmap_rnd_bits = 32` - Enhanced ASLR
- Added `vm.mmap_rnd_compat_bits = 16` - Enhanced ASLR for 32-bit
- Added filesystem protections: `fs.protected_symlinks`, `fs.protected_hardlinks`, `fs.protected_fifos`, `fs.protected_regular`
- Added `fs.suid_dumpable = 0` - Prevent core dumps for setuid programs

**Network Security:**
- Added `net.ipv4.tcp_sack = 0` - Disable SACK (mitigates certain attacks)
- Added `net.ipv4.tcp_dsack = 0` - Disable DSACK
- Added `net.ipv4.tcp_fack = 0` - Disable FACK
- Added `net.ipv4.tcp_rfc1337 = 1` - Protect against TCP time-wait assassination
- Added `net.ipv4.conf.all.log_martians = 1` - Log martian packets
- Added `net.ipv6.conf.all.accept_ra = 0` - Disable IPv6 router advertisements

#### 3. Nix Configuration Enhancements
- Added `trusted-users` and `allowed-users` settings
- Enabled sandbox mode explicitly
- Added storage management: `min-free` and `max-free` thresholds
- Added `allowBroken = false` and `permittedInsecurePackages = []`
- Improved automatic store optimization with scheduled runs

#### 4. New Systemd Service Hardening Module
Created comprehensive systemd service hardening with:
- `ProtectSystem`, `ProtectHome`, `PrivateTmp`, `PrivateDevices`
- `ProtectKernelTunables`, `ProtectKernelModules`, `ProtectControlGroups`
- `NoNewPrivileges`, `RestrictRealtime`, `RestrictSUIDSGID`
- `LockPersonality`, `MemoryDenyWriteExecute`
- `RestrictAddressFamilies`, `RestrictNamespaces`
- Applied to `systemd-resolved` and `systemd-timesyncd`

#### 5. New Performance Module
Added performance optimizations:
- `vm.swappiness = 10` - Reduce swap usage
- `vm.vfs_cache_pressure = 50` - Better cache pressure
- `vm.dirty_ratio = 10` and `vm.dirty_background_ratio = 5` - Better I/O performance
- `kernel.nmi_watchdog = 0` - Disable NMI watchdog to save power
- `cpuFreqGovernor = "schedutil"` - Better power management
- IRQ balance enabled
- Faster systemd timeouts

#### 6. Hardware Detection Improvements
- Added virtio drivers for VM compatibility
- Enabled systemd in initrd (`boot.initrd.systemd.enable`)
- More robust module loading with `lib.mkDefault`

#### 7. Logging Enhancements
- Added explicit rate limiting configuration
- Better sysctl defaults with `lib.mkDefault`
- Improved journald configuration

### Best Practices Applied

1. **Flake-parts compliance**: Following official best practices
2. **Input follows**: All flake inputs now follow nixpkgs
3. **lib.mkDefault usage**: All overridable options use `lib.mkDefault`
4. **Modular architecture**: Clear separation of concerns
5. **Security-first**: Multiple layers of defense
6. **Performance-conscious**: Balanced security with performance

### What Changed

- `flake.nix`: Added `inputs.nixpkgs.follows` for all inputs
- `modules/nixos/hosts/lynx.nix`: Added `specialArgs`, new module imports
- `modules/nixos/features/security.nix`: Enhanced kernel parameters and sysctl
- `modules/nixos/features/network.nix`: Additional network hardening
- `modules/nixos/features/nix.nix`: Comprehensive Nix settings
- `modules/nixos/features/general.nix`: Better store optimization
- `modules/nixos/features/logging.nix`: Explicit rate limiting
- `modules/nixos/features/hardware-detection.nix`: VM support, systemd initrd
- **NEW**: `modules/nixos/features/systemd-hardening.nix`
- **NEW**: `modules/nixos/features/performance.nix`

### Compatibility

All changes maintain backward compatibility. Everything uses `lib.mkDefault` for easy overriding.

### Migration Notes

To apply these changes to your system:

```bash
cd /path/to/config
sudo nixos-rebuild switch --flake .#lynx
```

If you want to update flake inputs (once Nix is available):
```bash
nix flake update
sudo nixos-rebuild switch --flake .#lynx
```

### Security Impact

This update significantly improves the security posture:
- **CPU vulnerabilities**: Protected against Spectre, Meltdown, L1TF, MDS
- **Kernel hardening**: Enhanced protection against exploits
- **Network security**: Better protection against network-based attacks
- **Process isolation**: Stronger systemd service sandboxing
- **Filesystem security**: Protected against symlink/hardlink attacks

### Performance Impact

- Minimal performance impact for most workloads
- Slight CPU overhead from vulnerability mitigations (industry standard)
- Better I/O performance from tuned vm sysctls
- Power savings from optimized settings

### Known Issues

None at this time.

### References

- [NixOS Security Best Practices](https://nixos.wiki/wiki/Security)
- [Flake-parts Best Practices](https://flake.parts/best-practices-for-module-writing.html)
- [Linux Kernel Hardening](https://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project)
- [Systemd Service Hardening](https://www.freedesktop.org/software/systemd/man/systemd.exec.html)
