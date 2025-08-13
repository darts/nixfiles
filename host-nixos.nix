# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  age.secrets = {
    dartsPassword.file = ./secrets/host-nixos-password.age;  
  };

  nix = {
    channel.enable = false;
    settings = {
      trusted-users = ["@wheel"];
      experimental-features = ["nix-command" "flakes" "ca-derivations"];
    };
  };

  systemd.network = {
    enable = true;
    links = {
      "10-usb-eth" = {
        matchConfig.PermanentMACAddress = "00:e0:4c:b8:0b:f5";
        linkConfig.Name = "usb-eth";
      };
    };
    networks = {
      "10-lan" = {
        name = "usb-eth";
        DHCP = "yes";
      };
    }; 
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_12;

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.darts = {
    packages = with pkgs; [
	git
	htop
    ];
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    hashedPasswordFile = config.age.secrets.dartsPassword.path;
    openssh.authorizedKeys.keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCv7v2WQd/x9Z+fFFB9wOgJqq5fHcVecHYE0AmjDWwgTE8FLrg1RkSDILlHxNgxxHdeL4yxq/EL3WPZ7CVsfC+Fi80FqHHFUkwpMpyGkBCKWJoRHTz/xRe/lxNOkDrJPPGPvvNtmAJvEqf6gkW5BgRgCGBmEQ4GKz2aawyitw2l+k3/lhQggXyQg9IYClFw+AUcVImfZwZ/VYamq4Al77kXNT5e0BlWKe0/alLe/TZbdQ0jRGWhrSIMJG7KXoc1BB7oxUoehFC3sz/DxAZaXa1Eu8bZ8XzO7a7tyBHFC10Ub7EmzfJFxX7rqaqGnSVrK3RyEjE7qwBUzjigC2vXHCa7"];
  };
  security.sudo.wheelNeedsPassword = false;

  users.mutableUsers = false;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    tree
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.tmux = {
    enable = true;
    historyLimit = 500000;
    keyMode = "vi";
  };
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.logind.lidSwitch = "ignore";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}

