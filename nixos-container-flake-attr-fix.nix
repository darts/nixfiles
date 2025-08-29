(final: prev: {
  nixos-container = prev.nixos-container.overrideAttrs {
    src = prev.runCommand "nixos-containers-flake-attr-fix.pl" {
      orig = prev.nixos-container.src;
      patch = ./nixos-container-flake-attr-fix.patch;
    } ''
      patch $orig $patch -o $out
    '';
  };
})
