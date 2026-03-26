# Customization Summary for Lynx

## What Was Changed

This fork was heavily modified to create a minimal, personal NixOS configuration with the following specifications:

### System Details
- **Hostname**: lynx
- **Username**: lynx (only user)
- **Timezone**: Asia/Karachi (UTC+5)
- **Bootloader**: systemd-boot
- **Kernel**: Latest Linux kernel (linuxPackages_latest)

### Window Manager & Display
- **Compositor**: Niri (Wayland)
- **XWayland**: xwayland-satellite
- **Portal**: xdg-desktop-portal-wlr (WLR only)
- **Wallpaper**: swaybg
- **No login manager**: Auto-login to Niri session on VT1

### Core Applications
- **Terminal**: Kitty with custom Gruvbox theme
- **Browser**: Brave
- **Launcher**: tofi
- **File Manager**: None (add if needed)

### System Services
- **Audio**: PipeWire (ALSA, PulseAudio, JACK)
- **Bluetooth**: Enabled with Blueman
- **Network**: wpa_supplicant (NO NetworkManager, NO dhcpcd)
- **Time Sync**: systemd-timesyncd
- **Input**: caps2esc via interception-tools

### Utilities Included
- brightnessctl (brightness control)
- playerctl (media control)
- hyprpicker (color picker)
- btop (system monitor)
- wpa_gui (WiFi management GUI)

### What Was Removed
All the original features from the parent repository were stripped out:
- No desktop environment
- No bars/panels
- No extra applications (Discord, Telegram, Firefox, gaming tools, etc.)
- No impermanence
- No Hyprland
- No NetworkManager
- No additional features

## File Structure

```
modules/nixos/hosts/lynx/
├── configuration.nix       # Main system configuration
├── hardware-configuration.nix  # Hardware-specific settings (update for your system)
├── niri-config.kdl        # Niri window manager config
└── kitty.conf             # Kitty terminal config
```

## Configuration Files

### Niri Config (`~/.config/niri/config.kdl`)
- Your exact keybindings and window rules
- 9 workspaces
- Gaps: 20px
- Focus ring: green (#b8bb26)
- No animations
- Multi-monitor support (HDMI-A-1 and eDP-1)
- Arabic keyboard layout support

### Kitty Config (`~/.config/kitty/kitty.conf`)
- Gruvbox color scheme
- JetBrainsMono Nerd Font at 15pt
- Tab switching with Alt+1-9
- Custom keybindings

## How to Build

```bash
# Build the configuration
sudo nixos-rebuild switch --flake .#lynx

# Update packages
nix flake update
sudo nixos-rebuild switch --flake .#lynx
```

## Network Configuration

Since NetworkManager is not used, WiFi is managed via wpa_supplicant:

```bash
# GUI method
wpa_gui

# Command line method
wpa_passphrase "SSID" "PASSWORD" | sudo tee -a /etc/wpa_supplicant.conf
sudo systemctl restart wpa_supplicant
```

## Rolling Release Approach

This configuration uses:
- `pkgs.linuxPackages_latest` for the latest kernel
- Latest versions of all packages from nixpkgs unstable
- Similar to Arch Linux's rolling release model

## Future Customizations

To add more packages, edit `modules/nixos/hosts/lynx/configuration.nix` and add them to `environment.systemPackages`.

To modify Niri behavior, edit `modules/nixos/hosts/lynx/niri-config.kdl`.

To change Kitty appearance, edit `modules/nixos/hosts/lynx/kitty.conf`.

## Notes

1. **Wallpaper**: Add your own wallpaper at `/home/lynx/wallpaper.png`
2. **Screenshots**: Saved to `~/Pictures/Screenshots/`
3. **Hardware Config**: Update `hardware-configuration.nix` with your actual hardware details after running `nixos-generate-config`
4. **helium-browser**: Referenced in niri config but not installed (add if needed)
5. **Caps Lock → Escape**: Handled by caps2esc interception tool
