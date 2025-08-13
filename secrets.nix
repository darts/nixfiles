let 
  dev = "age12n06s02xp8yyevluutvtrk9jy7caggxyz6wt2v5yc506kc5mfpcq84pds9";
  hostNixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIv3eTP0F10InIKS1CcILBcWU1kDDkgFgbKpF/qgJXJE";
in
{
  "secrets/host-nixos-password.age".publicKeys = [ dev hostNixos ];
}
