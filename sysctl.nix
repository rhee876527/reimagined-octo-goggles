{ config, lib, pkgs, ... }:
{
  # All my sysctls
  boot.kernel.sysctl."dev.tty.legacy_tiocsti" = lib.mkOverride 500 0;
  boot.kernel.sysctl."vm.oom_kill_allocating_task" = lib.mkOverride 500 1;
  boot.kernel.sysctl."kernel.sysrq" = lib.mkOverride 500 0;
  boot.kernel.sysctl."kernel.nmi_watchdog" = lib.mkOverride 500 0;
  boot.kernel.sysctl."vm.swappiness" = lib.mkOverride 500 10;
  boot.kernel.sysctl."vm.max_map_count" = lib.mkOverride 500 1048576;
}
