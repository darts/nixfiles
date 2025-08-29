{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./common.nix
    ];

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;
  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/ec118728-d5a1-4f7e-a609-83b033e7c0e8";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/B908-4D72";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/de8cf869-aa8e-46eb-8441-ebba080ab2c1"; }
    ];

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  systemd.network = {
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

  programs.git.config = {
    safe.directory = "/etc/nixos";
  };

  services.logind.lidSwitch = "ignore";

  containers = {
    hoas = {
      flake = "/etc/nixos#hoas";
      autoStart = true;
      privateNetwork = true;
      hostBridge = "lan-bridge";
      privateUsers = "pick";
    };
  };
}

