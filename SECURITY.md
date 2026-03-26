# Security Guide for Lynx NixOS Configuration

## Overview

This document outlines the security measures implemented in this NixOS configuration and provides guidance for maintaining a secure system.

## Critical Security Considerations

### Authentication

**IMPORTANT**: The current configuration includes auto-login for the `lynx` user:

```nix
services.getty.autologinUser = "lynx";
```

**Security Implications**:
- Anyone with physical access to the machine can access the system without authentication
- While sudo is configured (can be set to require password), the initial login is unprotected
- This is suitable ONLY for single-user systems in physically secure locations

**Recommendations**:
1. Remove auto-login if this system is in a shared or public space:
   ```nix
   # Comment out or remove this line:
   # services.getty.autologinUser = "lynx";
   ```

2. Set a strong password for the lynx user:
   ```bash
   passwd
   ```

3. Enable password requirement for sudo by modifying `modules/nixos/features/security.nix`:
   ```nix
   security.sudo.wheelNeedsPassword = lib.mkDefault true;
   ```

### Disk Encryption

**CURRENT STATE**: The configuration does NOT include disk encryption.

**Recommendation**: For sensitive data, implement LUKS encryption during installation:

```bash
# During installation, before formatting:
cryptsetup luksFormat /dev/sdXn
cryptsetup open /dev/sdXn cryptroot
# Then format the opened device
```

Update hardware configuration to include:
```nix
boot.initrd.luks.devices = {
  cryptroot = {
    device = "/dev/disk/by-uuid/YOUR-UUID";
    preLVM = true;
  };
};
```

## Implemented Security Measures

### Network Security

The configuration includes comprehensive network hardening:

1. **Firewall**: Enabled with restrictive defaults
   - No incoming connections allowed by default
   - Ping requests blocked
   - All ports closed unless explicitly opened

2. **Kernel Network Parameters**:
   - SYN flood protection enabled
   - IP spoofing protection
   - ICMP redirect protection
   - Source routing disabled

3. **DNS Security**:
   - DNS-over-TLS enabled (opportunistic)
   - DNSSEC validation
   - Secure fallback DNS servers (Cloudflare)

### Kernel Hardening

Multiple kernel-level protections are enabled:

1. **Memory Protection**:
   - Page table isolation (PTI) forced
   - Memory allocations zeroed on allocation and free
   - SLAB merging disabled
   - Kernel stack offset randomization

2. **Access Controls**:
   - Kernel pointer hiding (kptr_restrict=2)
   - Restricted dmesg access
   - Unprivileged BPF disabled
   - User namespaces restricted

3. **Unnecessary Modules Blocked**:
   - Legacy network protocols (DCCP, SCTP, RDS, TIPC)
   - Amateur radio protocols
   - Obsolete filesystems (cramfs, freevxfs, jffs2)

### Application Security

1. **AppArmor**: Enabled with mandatory confinement
   - Unconfined processes are terminated
   - Provides MAC (Mandatory Access Control)

2. **Remote Control**: Kitty remote control disabled
   ```
   allow_remote_control no
   listen_on none
   ```

3. **Clipboard Security**: Clipboard access requires confirmation
   ```
   clipboard_control write-clipboard write-primary read-clipboard-ask read-primary-ask
   ```

### System Hardening

1. **Sudo Configuration**:
   - Only wheel group members can use sudo
   - Session timeout: 30 minutes
   - No lecture messages

2. **Documentation**: Minimal documentation installed
   - Reduces attack surface
   - Only man pages retained

3. **Default Packages**: Removed
   - No unnecessary software installed by default

### Logging and Monitoring

1. **Systemd Journal**:
   - Maximum size: 500MB
   - Retention: 2 weeks
   - Compression enabled
   - Sealed logs (tamper detection)

2. **Coredumps**:
   - Enabled for debugging
   - Compressed and stored externally
   - Size limits enforced

## Security Checklist

### Initial Setup

- [ ] Set a strong password: `passwd`
- [ ] Review auto-login setting and disable if needed
- [ ] Enable password requirement for sudo if needed
- [ ] Consider implementing disk encryption
- [ ] Update firmware: Check BIOS/UEFI for latest version

### Regular Maintenance

- [ ] Update system weekly: `sudo nixos-rebuild switch --flake .#lynx`
- [ ] Review journal logs: `journalctl -p 3 -xb` (errors and above)
- [ ] Check failed login attempts: `journalctl -u systemd-logind`
- [ ] Monitor disk usage: `df -h`
- [ ] Review sudo usage: `journalctl SYSLOG_IDENTIFIER=sudo`

### Network Security

- [ ] Review firewall rules regularly
- [ ] Monitor network connections: `ss -tulpn`
- [ ] Check DNS resolution: `resolvectl status`
- [ ] Verify no unexpected listening ports: `ss -tlnp`

### Application Security

- [ ] Keep Brave browser updated (check regularly)
- [ ] Review installed packages: `nix-store --query --requisites /run/current-system`
- [ ] Audit user files in home directory
- [ ] Check for suspicious processes: `ps auxf`

## Threat Model

This configuration is designed for:

**Protected Against**:
- Network-based attacks (restrictive firewall)
- Common kernel exploits (hardened kernel)
- Memory corruption attacks (memory protections)
- Many privilege escalation attempts (AppArmor, kernel restrictions)

**NOT Protected Against**:
- Physical access attacks (no disk encryption, auto-login enabled)
- Sophisticated rootkits (no secure boot, no integrity checking)
- Social engineering
- Supply chain attacks (inherent to any software distribution)

## Incident Response

If you suspect a security breach:

1. **Immediate Actions**:
   ```bash
   # Disconnect network
   sudo nmcli networking off

   # Check currently logged-in users
   who

   # Review recent authentication attempts
   journalctl -u systemd-logind --since "1 hour ago"
   ```

2. **Investigation**:
   ```bash
   # Check for suspicious processes
   ps auxf | less

   # Review recent sudo usage
   journalctl SYSLOG_IDENTIFIER=sudo --since "24 hours ago"

   # Check network connections
   ss -tupn

   # Review modified files
   find /home/lynx -type f -mtime -1
   ```

3. **Recovery**:
   - Boot from a previous generation: Select in systemd-boot menu
   - Review changes: `nix-diff` between generations
   - If compromised, consider reinstalling from scratch

## Secrets Management

**CRITICAL**: Never commit secrets to version control.

The `.gitignore` includes `.env` files, but be aware:
- Nix store is world-readable
- Secrets in Nix files will be exposed
- Use secrets management for production:
  - [agenix](https://github.com/ryantm/agenix) (age-encrypted secrets)
  - [sops-nix](https://github.com/Mic92/sops-nix) (SOPS integration)

For development secrets (like the Supabase credentials):
1. Keep them in `.env` (already in `.gitignore`)
2. Never reference them in `.nix` files
3. Load them at runtime in applications
4. Rotate them if they're ever exposed

## Additional Hardening Options

For even stronger security, consider:

1. **Secure Boot**:
   ```nix
   boot.loader.systemd-boot.enable = false;
   boot.lanzaboote.enable = true;
   ```

2. **TPM Integration**: Use TPM for disk encryption keys

3. **Sandboxing**: Use Firejail or systemd sandboxing for applications

4. **Network Isolation**: Use network namespaces for untrusted applications

5. **Regular Auditing**: Enable `auditd` for comprehensive system auditing

6. **Two-Factor Authentication**: Configure PAM for 2FA

## References

- [NixOS Security Wiki](https://nixos.wiki/wiki/Security)
- [Kernel Hardening](https://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project)
- [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks/)
- [AppArmor Documentation](https://gitlab.com/apparmor/apparmor/-/wikis/home)

## Support

For security issues specific to this configuration:
- Review the configuration files in `modules/nixos/features/`
- Check NixOS manual for options: `man configuration.nix`
- NixOS Discourse: https://discourse.nixos.org/

---

**Last Updated**: 2026-03-26
**Configuration Version**: 1.0
