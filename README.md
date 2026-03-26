# Lynx NixOS Configuration

Minimal NixOS configuration for user "lynx" using the Goxore nixconf structure.

## Features

- **Display Manager**: Niri compositor (no login manager, auto-login)
- **Terminal**: Kitty with Gruvbox theme
- **Browser**: Brave
- **Audio**: PipeWire (ALSA, PulseAudio, JACK)
- **Bluetooth**: Enabled
- **Input**: caps2esc via interception-tools
- **Networking**: DHCP (Ethernet only, no WiFi)
- **Time Sync**: systemd-timesyncd
- **Timezone**: Asia/Karachi (UTC+5)
- **Bootloader**: systemd-boot
- **X11 Support**: xwayland-satellite

## Module Structure

```
modules/
├── flake-parts.nix
├── nixos/
│   ├── base/                    # Base options
│   │   └── base.nix
│   ├── features/                # Feature modules
│   │   ├── general.nix
│   │   ├── desktop.nix
│   │   ├── nix.nix
│   │   ├── pipewire.nix
│   │   └── wallpaper.nix
│   ├── extra/                   # Optional extras
│   │   └── hjem.nix
│   └── hosts/                   # Host-specific configs
│       ├── lynx.nix             # Main host configuration
│       └── lynx/                # Host-specific files
│           ├── niri-config.kdl
│           └── kitty.conf
```

## Installation

1. Update hardware configuration in `modules/nixos/hosts/lynx.nix` (the `hardwareLynx` module) with your hardware details

2. Build and switch:
```bash
sudo nixos-rebuild switch --flake .#lynx
```

For initial installation:
```bash
sudo nixos-install --flake .#lynx
```

## Post-Installation

- Change password: `passwd`
- Connect to Ethernet (automatic via DHCP)
- Configure niri/kitty as needed

## Module Organization

This configuration uses `import-tree` to automatically load all `.nix` files in the `modules/` directory. Each module exports `flake.nixosModules.<name>` that can be imported into host configurations.

- **Base modules** (`base/`): Define core options and user preferences
- **Feature modules** (`features/`): Self-contained functionality (desktop, audio, networking, etc.)
- **Extra modules** (`extra/`): Optional enhancements like hjem for home file management
- **Host modules** (`hosts/`): Host-specific configurations combining feature modules

The `lynx` host configuration in `modules/nixos/hosts/lynx.nix` imports all necessary modules and defines host-specific settings. This structure avoids circular dependencies and follows NixOS best practices.
