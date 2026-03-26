# NixOS Configuration Compatibility Guide

## Hardware Compatibility

This configuration has been designed to work across different hardware platforms with automatic detection and adaptation.

### Supported Architectures
- **x86_64 (Intel/AMD)**: Full support
- **ARM64**: Partial support (requires testing)

### Automatic Hardware Detection

The configuration includes the `hardware-detection` module that automatically:
- Detects and loads appropriate kernel modules for Intel and AMD CPUs
- Includes drivers for common storage controllers (NVMe, AHCI, USB)
- Enables microcode updates for both Intel and AMD processors
- Configures appropriate kernel modules for virtualization (KVM)

### What Works Out of the Box

✅ **Storage Controllers:**
- NVMe drives
- SATA/AHCI controllers
- USB storage devices
- SD card readers (including Realtek)

✅ **Graphics:**
- Intel integrated graphics
- AMD graphics
- NVIDIA graphics (with modesetting driver)
- Multi-GPU setups

✅ **Input Devices:**
- USB keyboards/mice
- Touchpads
- Bluetooth devices

✅ **Audio:**
- PipeWire with full ALSA/PulseAudio/JACK compatibility
- Bluetooth audio devices

✅ **Network:**
- Most Ethernet controllers
- WiFi adapters (via NetworkManager or systemd-networkd)
- Bluetooth connectivity

### Known Limitations

⚠️ **Filesystem Configuration:**
- The current configuration expects:
  - Root partition labeled "nixos" (ext4)
  - Boot partition labeled "boot" (vfat/FAT32)
- **For different setups, you must modify** `modules/nixos/hosts/lynx.nix:hardwareLynx`

⚠️ **Display Server:**
- Configured for Niri (Wayland compositor)
- May require additional configuration for X11
- Some proprietary NVIDIA features need additional setup

⚠️ **Keyboard Layout:**
- Default: US English with Arabic (Buckwalter)
- Toggle with Caps Lock
- Modify in `modules/nixos/hosts/lynx/niri-config.kdl` for different layouts

## Installation on Different Machines

### Step 1: Boot NixOS Installer

Boot from NixOS installation media (USB/CD).

### Step 2: Partition Your Disk

**IMPORTANT:** Adjust partition sizes based on your needs. The labels MUST match the configuration.

```bash
# Example for a single disk (/dev/sda)
# Replace /dev/sda with your actual disk (check with `lsblk`)

# Create GPT partition table
parted /dev/sda -- mklabel gpt

# Create boot partition (512MB - 1GB recommended)
parted /dev/sda -- mkpart ESP fat32 1MB 512MB
parted /dev/sda -- set 1 esp on

# Create root partition (use remaining space)
parted /dev/sda -- mkpart primary ext4 512MB 100%

# Format partitions with REQUIRED labels
mkfs.fat -F 32 -n boot /dev/sda1
mkfs.ext4 -L nixos /dev/sda2

# Mount partitions
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
```

### Step 3: Clone Configuration

```bash
# Install git
nix-shell -p git

# Clone this repository
cd /mnt
git clone https://github.com/yourusername/your-repo.git /mnt/etc/nixos-config
```

### Step 4: Customize for Your Machine

Edit `/mnt/etc/nixos-config/modules/nixos/hosts/lynx.nix`:

1. **Change hostname** (if desired):
   ```nix
   networking.hostName = "your-hostname";
   ```

2. **Adjust timezone**:
   ```nix
   time.timeZone = "Your/Timezone";  # e.g., "America/New_York"
   ```

3. **Configure username** (optional):
   - If you want a different username, modify `modules/nixos/features/general.nix`
   - Update references in `modules/nixos/hosts/lynx.nix`

4. **Set a password** (RECOMMENDED):
   ```nix
   users.users.lynx.initialHashedPassword = "your-hashed-password";
   ```
   Generate a hashed password with:
   ```bash
   mkpasswd -m sha-512
   ```

5. **Disable auto-login** (RECOMMENDED for security):
   ```nix
   services.getty.autologinUser = lib.mkForce null;
   ```

### Step 5: Install

```bash
cd /mnt
nixos-install --flake /mnt/etc/nixos-config#lynx
```

### Step 6: Set Root Password

```bash
nixos-enter --root /mnt -c 'passwd'
```

### Step 7: Reboot

```bash
reboot
```

## Post-Installation

### First Boot

If auto-login is enabled, the system will automatically:
1. Log in as the configured user
2. Start Niri Wayland compositor
3. Display a desktop environment

### Setting User Password

Even with auto-login, set a password for sudo and manual logins:
```bash
passwd
```

### Updating the System

```bash
sudo nixos-rebuild switch --flake /etc/nixos-config#lynx
```

### Installing Additional Packages

Add packages to `environment.systemPackages` in your configuration or use:
```bash
nix-shell -p package-name  # Temporary
```

## Adapting to Different Hardware

### For AMD Graphics

No changes needed - the configuration auto-detects AMD hardware.

### For NVIDIA Graphics

Add to `modules/nixos/hosts/lynx.nix`:
```nix
services.xserver.videoDrivers = [ "nvidia" ];
hardware.nvidia.modesetting.enable = true;
hardware.nvidia.open = false;  # Set true for 515+ open-source driver
```

### For Different Filesystems

If using Btrfs, XFS, or other filesystems:

1. Edit `modules/nixos/hosts/lynx.nix:hardwareLynx`:
   ```nix
   fileSystems."/" = {
     device = "/dev/disk/by-label/nixos";
     fsType = "btrfs";  # or "xfs", etc.
     options = [ "subvol=root" "compress=zstd" "noatime" ];  # Btrfs example
   };
   ```

### For Encrypted Drives (LUKS)

Add to `modules/nixos/hosts/lynx.nix:hardwareLynx`:
```nix
boot.initrd.luks.devices = {
  cryptroot = {
    device = "/dev/disk/by-uuid/YOUR-UUID-HERE";
    preLVM = true;
  };
};

fileSystems."/" = {
  device = "/dev/mapper/cryptroot";
  fsType = "ext4";
  options = [ "defaults" "noatime" ];
};
```

### For Multiple Monitors

Edit `modules/nixos/hosts/lynx/niri-config.kdl` to add/modify output sections:
```kdl
output "HDMI-A-1" {
    scale 1
    mode "1920x1080@60"
    position x=0 y=0
}

output "DP-1" {
    scale 1
    mode "2560x1440@144"
    position x=1920 y=0
}
```

## Troubleshooting

### System Won't Boot

1. Boot into NixOS installer
2. Mount your partitions
3. Check configuration errors:
   ```bash
   nixos-enter --root /mnt
   nixos-rebuild dry-build --flake /etc/nixos-config#lynx
   ```

### Graphics Issues

Try booting with nomodeset:
1. At boot menu, press 'e'
2. Add `nomodeset` to kernel parameters
3. Boot and install appropriate drivers

### WiFi Not Working

Check if your adapter needs proprietary firmware:
```bash
lspci -k | grep -A 3 Network
```

Enable unfree firmware in `modules/nixos/features/nix.nix` (already enabled in this config):
```nix
nixpkgs.config.allowUnfree = true;
hardware.enableRedistributableFirmware = true;  # Already in hardware-detection
```

### Different Keyboard Layout Needed

Edit `modules/nixos/hosts/lynx/niri-config.kdl`:
```kdl
input {
    keyboard {
        xkb {
            layout "us,de"  # Example: US and German
            variant ""
            options "grp:alt_shift_toggle"  # Switch with Alt+Shift
        }
    }
}
```

## Security Considerations

### Current Security Posture

✅ **Strong:**
- Kernel hardening enabled
- AppArmor mandatory access control
- Network firewall with restrictive defaults
- Secure DNS (DNS-over-TLS, DNSSEC)
- Memory protection features
- Disabled unnecessary kernel modules

⚠️ **Weak:**
- Auto-login enabled (anyone with physical access can use the system)
- No disk encryption
- Empty password by default

### Recommended Security Improvements

1. **Disable auto-login:**
   ```nix
   services.getty.autologinUser = lib.mkForce null;
   ```

2. **Set strong password:**
   ```bash
   passwd
   ```

3. **Enable password for sudo:**
   ```nix
   security.sudo.wheelNeedsPassword = lib.mkForce true;
   ```

4. **Enable disk encryption during installation** (see LUKS section above)

5. **Review** `SECURITY.md` for comprehensive security guidance

## Performance Tuning

### For Low-Memory Systems (<4GB RAM)

Disable Niri animations and reduce compositor effects:
```nix
# Already disabled in niri-config.kdl
animations { off }
```

### For High-Performance Systems

Enable zram compression:
```nix
preferences.filesystem.enableZram = true;
```

Use tmpfs for /tmp:
```nix
boot.tmp.useTmpfs = true;
```

### For Battery Life (Laptops)

Enable TLP:
```nix
services.tlp.enable = true;
services.power-profiles-daemon.enable = false;
```

## Getting Help

- **NixOS Manual:** https://nixos.org/manual/nixos/stable/
- **NixOS Wiki:** https://nixos.wiki/
- **Community:** https://discourse.nixos.org/
- **Configuration Search:** https://search.nixos.org/

## Version Information

- **NixOS Version:** 24.11 (state version)
- **Channel:** nixos-unstable
- **Last Updated:** 2026-03-26
