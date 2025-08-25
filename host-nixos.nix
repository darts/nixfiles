{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./common.nix
    ];

  systemd.network = {
    enable = true;
    netdevs = {
      "10-lan-bridge".netdevConfig = {
        Name = "lan-bridge";
        Kind = "bridge";
      };
    };
    links = {
      "10-usb-eth" = {
        matchConfig.PermanentMACAddress = "00:e0:4c:b8:0b:f5";
        linkConfig.Name = "usb-eth";
      };
    };
    networks = {
      "10-usb-eth" = {
        name = "usb-eth";
        bridge = [ "lan-bridge" ];
      };
      "10-lan" = {
        name = "lan-bridge";
        DHCP = "yes";
      };
    }; 
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_12;

  networking.hostName = "nixos"; # Define your hostname.
  services.logind.lidSwitch = "ignore";
}

