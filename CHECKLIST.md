# Installation Checklist

## Pre-Installation

- [ ] Downloaded NixOS installation media
- [ ] Created bootable USB
- [ ] Backed up important data
- [ ] Know your WiFi SSID and password

## During Installation

- [ ] Booted from installation media
- [ ] Partitioned disk (GPT with ESP)
- [ ] Formatted partitions (FAT32 for boot, ext4 for root)
- [ ] Mounted partitions correctly
- [ ] Generated hardware config with `nixos-generate-config`
- [ ] Updated `hardware-configuration.nix` with your hardware details
- [ ] Cloned this repository to `/mnt/nixconf`
- [ ] Ran `sudo nixos-install --flake .#lynx`
- [ ] Set root password
- [ ] Rebooted

## Post-Installation

- [ ] System boots to auto-login
- [ ] Changed user password with `passwd`
- [ ] Copied wallpaper to `~/wallpaper.png`
- [ ] Connected to WiFi using `wpa_gui`
- [ ] Tested keyboard (Caps Lock → Escape works)
- [ ] Tested keyboard layout switching (Caps Lock for US/Arabic)
- [ ] Verified audio with `wpctl status`
- [ ] Tested media keys (volume, brightness)
- [ ] Paired Bluetooth devices (if any)
- [ ] Verified time and timezone with `timedatectl`

## Functionality Tests

- [ ] Launch terminal: `Mod+Q`
- [ ] Launch browser: `Mod+D`
- [ ] Open launcher: `Mod+Space`
- [ ] Switch workspaces: `Mod+1-9`
- [ ] Move windows: `Mod+Shift+1-9`
- [ ] Take screenshot: `Print`
- [ ] Close window: `Mod+C`
- [ ] Maximize: `Mod+F`
- [ ] Fullscreen: `Mod+Shift+F`
- [ ] Toggle floating: `Mod+V`

## XWayland Check

- [ ] xwayland-satellite is running: `ps aux | grep xwayland`
- [ ] X11 apps work (if you have any to test)

## Display Configuration

- [ ] Checked outputs: `niri msg outputs`
- [ ] Updated display config in `~/.config/niri/config.kdl` if needed
- [ ] Proper resolution and refresh rate

## System Verification

- [ ] Check niri is running: `ps aux | grep niri`
- [ ] Check pipewire: `systemctl --user status pipewire`
- [ ] Check bluetooth: `systemctl status bluetooth`
- [ ] Check time sync: `systemctl status systemd-timesyncd`
- [ ] Check interception: `systemctl status udevmon`

## Customization (Optional)

- [ ] Added additional packages to `configuration.nix`
- [ ] Modified niri keybindings
- [ ] Customized kitty colors/fonts
- [ ] Added helper scripts to `~/.local/bin/`
- [ ] Configured browser preferences

## Updates

- [ ] Tested system update: `nix flake update && sudo nixos-rebuild switch --flake .#lynx`
- [ ] Bookmark this repository location
- [ ] Set up git for tracking your changes

## Backups

- [ ] Backed up `~/.config/niri/config.kdl`
- [ ] Backed up `~/.config/kitty/kitty.conf`
- [ ] Noted your WiFi configuration
- [ ] Documented any additional customizations

## Final Verification

- [ ] System boots without errors
- [ ] All peripherals work (mouse, keyboard, etc.)
- [ ] Audio works (output and input)
- [ ] Network connectivity stable
- [ ] Display looks correct
- [ ] Comfortable with basic keybindings
- [ ] Know how to update system
- [ ] Know how to install new packages

## If Something Doesn't Work

1. Check logs: `journalctl -xe`
2. Check service status: `systemctl status <service>`
3. Verify config syntax in `.kdl` and `.nix` files
4. Try rebuilding: `sudo nixos-rebuild switch --flake .#lynx`
5. Reboot and test again

## Notes

Write any issues or customizations here:

```
[Your notes]
```

---

**Status**: [ ] Installation Complete [ ] Ready to Use

**Date**: _______________

**Version**: _______________
