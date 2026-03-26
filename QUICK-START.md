# Quick Start Guide

## Prerequisites

You need:
1. NixOS installation media
2. Your hardware ready
3. This repository

## Installation Steps

### 1. Boot Installation Media

Boot from NixOS USB/CD.

### 2. Partition Your Disk

Example for a single disk setup:

```bash
# Using parted (GPT)
sudo parted /dev/sda -- mklabel gpt
sudo parted /dev/sda -- mkpart ESP fat32 1MB 512MB
sudo parted /dev/sda -- set 1 esp on
sudo parted /dev/sda -- mkpart primary ext4 512MB 100%

# Format
sudo mkfs.fat -F 32 -n boot /dev/sda1
sudo mkfs.ext4 -L nixos /dev/sda2

# Mount
sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/boot /mnt/boot
```

### 3. Get Hardware Info

```bash
sudo nixos-generate-config --root /mnt
cat /mnt/etc/nixos/hardware-configuration.nix
```

Copy the output and update `modules/nixos/hosts/lynx/hardware-configuration.nix` with your actual:
- `boot.initrd.availableKernelModules`
- `boot.kernelModules`
- Any special hardware settings

### 4. Clone Repository

```bash
cd /mnt
sudo nix-shell -p git
sudo git clone <YOUR_REPO_URL> nixconf
cd nixconf
```

### 5. Install

```bash
sudo nixos-install --flake .#lynx
```

Set root password when prompted.

### 6. Reboot

```bash
sudo reboot
```

## First Boot

You'll auto-login as user `lynx` into Niri.

### Change Password

```bash
passwd
```

### Add Wallpaper

```bash
# Copy your wallpaper
cp /path/to/image.png ~/wallpaper.png
```

### Connect WiFi

Press `Mod+Space` (Super+Space) and type `wpa_gui`, or from terminal:

```bash
wpa_gui
```

Select your network and enter password.

## Key Bindings

- `Mod+Q`: Terminal (Kitty)
- `Mod+D`: Browser (Brave)
- `Mod+Space`: Launcher (tofi)
- `Mod+C`: Close window
- `Mod+H/L`: Navigate left/right
- `Mod+J/K`: Navigate workspaces
- `Mod+1-9`: Switch to workspace
- `Mod+Shift+1-9`: Move window to workspace
- `Mod+F`: Maximize
- `Mod+Shift+F`: Fullscreen
- `Mod+V`: Toggle floating
- `Print`: Screenshot
- Media keys: Work as expected

## Common Tasks

### Update System

```bash
cd ~/nixconf  # or wherever you cloned it
nix flake update
sudo nixos-rebuild switch --flake .#lynx
```

### Install New Package

Edit `modules/nixos/hosts/lynx/configuration.nix`:

```nix
environment.systemPackages = with pkgs; [
  # ... existing packages ...
  your-new-package
];
```

Then rebuild:
```bash
sudo nixos-rebuild switch --flake .#lynx
```

### Check System Status

```bash
# Audio
wpctl status

# Bluetooth
bluetoothctl

# WiFi
ip link
wpa_cli status

# Displays
niri msg outputs

# System info
btop
```

## Troubleshooting

### Screen Not Working

Check monitors:
```bash
niri msg outputs
```

Update display config in `~/.config/niri/config.kdl`.

### Keyboard Layout Issues

Check current layout in niri config. Default is US + Arabic with Caps Lock as layout toggle.

### XWayland Apps Not Working

Check xwayland-satellite:
```bash
ps aux | grep xwayland
```

Should be running automatically.

### No Internet

Check WiFi:
```bash
ip link  # Check if interface is up
wpa_cli status  # Check WiFi connection
```

Reconfigure if needed with `wpa_gui`.

## Files to Customize

- `~/.config/niri/config.kdl`: Niri settings
- `~/.config/kitty/kitty.conf`: Terminal settings
- `modules/nixos/hosts/lynx/configuration.nix`: System packages

## Support

Check logs:
```bash
journalctl -xe  # System logs
journalctl -u niri  # Niri logs
```

That's it! Enjoy your minimal NixOS setup.
