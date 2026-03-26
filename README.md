# Lynx NixOS Configuration

Minimal NixOS configuration for user "lynx" using the Goxore nixconf structure.

## Features

- **Display Manager**: Niri compositor (no login manager, auto-login)
- **Terminal**: Kitty with Catppuccin Mocha theme
- **Browser**: Brave
- **Audio**: PipeWire (ALSA, PulseAudio, JACK)
- **Bluetooth**: Enabled
- **Input**: caps2esc via interception-tools
- **Networking**: Hardened with firewall, DNS-over-TLS, and kernel protections
- **Security**: Kernel hardening, AppArmor, restrictive firewall
- **Time Sync**: Cloudflare and Google NTP servers
- **Timezone**: Asia/Karachi (UTC+5)
- **Bootloader**: systemd-boot
- **X11 Support**: xwayland-satellite
- **Logging**: Compressed journals with 2-week retention

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
│   │   ├── network.nix
│   │   ├── security.nix
│   │   └── logging.nix
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
- **Feature modules** (`features/`): Self-contained functionality
  - `general.nix`: User management and system basics
  - `desktop.nix`: Desktop environment packages and fonts
  - `nix.nix`: Nix daemon settings and flakes
  - `pipewire.nix`: Audio system
  - `network.nix`: Firewall, DNS-over-TLS, and network hardening
  - `security.nix`: Kernel hardening, AppArmor, and system security
  - `logging.nix`: Journal and coredump configuration
- **Extra modules** (`extra/`): Optional enhancements like hjem for home file management
- **Host modules** (`hosts/`): Host-specific configurations combining feature modules

The `lynx` host configuration in `modules/nixos/hosts/lynx.nix` imports all necessary modules and defines host-specific settings. This structure avoids circular dependencies and follows NixOS best practices.

## Security

**IMPORTANT**: This configuration includes auto-login and passwordless sudo. See [SECURITY.md](SECURITY.md) for:
- Critical security considerations
- Implemented security measures
- Security checklist
- Incident response procedures
- Recommended hardening steps

For production or multi-user systems, review and adjust security settings in `modules/nixos/features/security.nix`.
