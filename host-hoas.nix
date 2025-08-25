
{ config, lib, pkgs, ... }:

{
  imports = [
    ./common.nix
  ];

  boot.isContainer = true;
}
