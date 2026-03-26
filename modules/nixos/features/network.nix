{...}: {
  flake.nixosModules.network = {pkgs, ...}: {
    networking.firewall = {
      enable = true;
      allowPing = false;
      logRefusedConnections = false;
      logRefusedPackets = false;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };

    networking.networkmanager.enable = false;

    services.resolved = {
      enable = true;
      dnssec = "allow-downgrade";
      fallbackDns = ["1.1.1.1" "1.0.0.1"];
      extraConfig = ''
        DNSOverTLS=opportunistic
      '';
    };

    services.timesyncd = {
      enable = true;
      servers = [
        "time.cloudflare.com"
        "time.google.com"
      ];
    };

    boot.kernel.sysctl = {
      "net.ipv4.tcp_syncookies" = 1;
      "net.ipv4.tcp_syn_retries" = 5;
      "net.ipv4.conf.default.rp_filter" = 1;
      "net.ipv4.conf.all.rp_filter" = 1;
      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.secure_redirects" = 0;
      "net.ipv4.conf.default.secure_redirects" = 0;
      "net.ipv6.conf.all.accept_redirects" = 0;
      "net.ipv6.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.send_redirects" = 0;
      "net.ipv4.conf.default.send_redirects" = 0;
      "net.ipv4.icmp_echo_ignore_all" = 1;
      "net.ipv6.conf.all.accept_source_route" = 0;
      "net.ipv6.conf.default.accept_source_route" = 0;
      "kernel.yama.ptrace_scope" = 2;
    };
  };
}
