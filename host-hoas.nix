
{ config, lib, pkgs, ... }:

{
  imports = [
    ./common.nix
  ];

  boot.isContainer = true;

  systemd.network = {
    networks."10-host" = {
      name = "eth0";
      DHCP = "yes";
    };
  };
}
