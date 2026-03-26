# Lynx NixOS Configuration

This is a minimal NixOS configuration customized for user `lynx`.

## Features

- **Window Manager**: Niri (Wayland compositor)
- **Terminal**: Kitty with custom Gruvbox theme
- **Browser**: Brave
- **Audio**: PipeWire with ALSA, PulseAudio, and JACK support
- **Bluetooth**: Enabled with Blueman
- **Network**: wpa_supplicant (no NetworkManager)
- **Time Sync**: systemd-timesyncd
- **Timezone**: Asia/Karachi (UTC+5)
- **Bootloader**: systemd-boot
- **XWayland**: xwayland-satellite
- **Portal**: wlr portal only
- **Caps Lock**: Remapped to Escape via caps2esc
- **No login manager**: Auto-login to Niri session

## Installation

1. Clone this repository
2. Update your hardware configuration if needed
3. Build and switch:
   ```bash
   sudo nixos-rebuild switch --flake .#lynx
   ```

## User Details

- Username: `lynx`
- Groups: wheel, video, audio, input
- Initial password: `12345` (change after first login)

## File Locations

- Niri config: `/home/lynx/.config/niri/config.kdl`
- Kitty config: `/home/lynx/.config/kitty/kitty.conf`
- Wallpaper: `/home/lynx/wallpaper.png` (add your own)

## Network Setup

WiFi is managed via `wpa_supplicant`. To connect:

```bash
# GUI
wpa_gui

# OR via command line
wpa_passphrase "SSID" "PASSWORD" | sudo tee -a /etc/wpa_supplicant.conf
sudo systemctl restart wpa_supplicant
```

## Key Bindings (from Niri config)

- `Mod+Q`: Launch Kitty
- `Mod+D`: Launch Brave
- `Mod+Space`: Application launcher (tofi)
- `Mod+C`: Close window
- `Mod+H/L`: Navigate left/right
- `Mod+1-9`: Switch workspaces
- `Mod+Shift+1-9`: Move window to workspace
- Media keys: Volume, brightness, playback controls work as expected

## Customization

Edit the configuration files in `modules/nixos/hosts/lynx/`:
- `configuration.nix`: Main system configuration
- `niri-config.kdl`: Niri window manager settings
- `kitty.conf`: Kitty terminal settings
- `hardware-configuration.nix`: Hardware-specific settings

## Rolling Updates

This configuration uses `pkgs.linuxPackages_latest` and the latest versions of all packages from nixpkgs unstable, similar to Arch Linux's rolling release model.

To update:
```bash
nix flake update
sudo nixos-rebuild switch --flake .#lynx
```
