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
├── theme.nix
├── nixos/
│   ├── base/                    # Base options
│   │   ├── start.nix
│   │   └── user.nix
│   ├── features/                # Feature modules
│   │   ├── general.nix
│   │   ├── desktop.nix
│   │   ├── nix.nix
│   │   ├── pipewire.nix
│   │   └── wallpaper/
│   │       └── wallpaper.nix
│   ├── extra/                   # Optional extras
│   │   └── hjem/
│   │       └── hjem.nix
│   └── hosts/                   # Host-specific configs
│       └── lynx/
│           ├── configuration.nix
│           ├── hardware-configuration.nix
│           ├── niri-config.kdl
│           └── kitty.conf
└── wrappedPrograms/             # Application wrappers
```

## Installation

1. Update `modules/nixos/hosts/lynx/hardware-configuration.nix` with your hardware

2. Copy wallpaper to home:
```bash
cp your-wallpaper.png /home/lynx/wallpaper.png
```

3. Build and install:
```bash
sudo nixos-install --flake .#lynx
```

## Post-Installation

- Change password: `passwd`
- Connect to Ethernet (automatic via DHCP)
- Configure niri/kitty as needed

## Module Organization

Each module in `features/` exports a `flake.nixosModules.<name>` that can be imported into host configurations. The base modules in `base/` define core options.

The `lynx` host in `modules/nixos/hosts/lynx/configuration.nix` imports all necessary modules and defines host-specific settings.
