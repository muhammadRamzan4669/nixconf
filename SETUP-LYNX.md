# Quick Setup Guide for Lynx Configuration

## 1. Prepare Installation Media

Boot from NixOS installation media and prepare your disk:

```bash
# Example disk setup (adjust for your needs)
# Partition disk
sudo parted /dev/sda -- mklabel gpt
sudo parted /dev/sda -- mkpart ESP fat32 1MB 512MB
sudo parted /dev/sda -- set 1 esp on
sudo parted /dev/sda -- mkpart primary 512MB 100%

# Format partitions
sudo mkfs.fat -F 32 -n boot /dev/sda1
sudo mkfs.ext4 -L nixos /dev/sda2

# Mount
sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/boot /mnt/boot
```

## 2. Generate Hardware Configuration

```bash
sudo nixos-generate-config --root /mnt
```

Copy the generated `/mnt/etc/nixos/hardware-configuration.nix` content and update `modules/nixos/hosts/lynx/hardware-configuration.nix` with your actual hardware details.

## 3. Clone This Repository

```bash
cd /mnt
sudo git clone https://github.com/YOUR_USERNAME/nixconf
cd nixconf
```

## 4. Install

```bash
sudo nixos-install --flake .#lynx
```

## 5. Set Root Password

When prompted, set a root password.

## 6. Reboot

```bash
sudo reboot
```

## 7. Post-Installation

After first boot, you'll auto-login as `lynx`. Change your password:

```bash
passwd
```

Add your wallpaper:
```bash
cp /path/to/your/wallpaper.png ~/wallpaper.png
```

## 8. WiFi Setup

Use `wpa_gui` for graphical WiFi management:
```bash
wpa_gui
```

Or configure via command line:
```bash
# Generate configuration
wpa_passphrase "YOUR_SSID" "YOUR_PASSWORD" | sudo tee -a /etc/wpa_supplicant.conf

# Restart service
sudo systemctl restart wpa_supplicant
```

## 9. Updates

Keep your system updated:
```bash
# Update flake inputs
nix flake update

# Rebuild system
sudo nixos-rebuild switch --flake .#lynx
```

## Troubleshooting

### Display Issues
Check your monitors with:
```bash
niri msg outputs
```

Update `output` sections in `~/.config/niri/config.kdl` accordingly.

### XWayland Not Working
Ensure xwayland-satellite is running:
```bash
ps aux | grep xwayland-satellite
```

If not, it should start automatically with niri.

### Keyboard Layout Not Working
The caps2esc interception should remap Caps Lock to Escape. If it doesn't work, check:
```bash
sudo systemctl status udevmon
```

### WiFi Not Connecting
Check wpa_supplicant status:
```bash
sudo systemctl status wpa_supplicant
```

View available networks:
```bash
sudo iw dev wlan0 scan | grep SSID
```
