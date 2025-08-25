{
  inputs = {
    # This is pointing to an unstable release.
    # If you prefer a stable release instead, you can this to the latest number shown here: https://nixos.org/download
    # i.e. nixos-24.11
    # Use `nix flake update` to update the flake to the latest revision of the chosen release channel.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    ragenix.url = "github:yaxitech/ragenix";
    ragenix.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs@{ self, nixpkgs, ... }: 
  let
    inherit (builtins) mapAttrs;
    system = "x86_64-linux";
    pkgs = import nixpkgs { 
      inherit system;
      overlays = [ inputs.ragenix.overlays.default ]; 
    };
  in {
    # NOTE: 'nixos' is the default hostname
    nixosConfigurations = mapAttrs (_: mainModule: nixpkgs.lib.nixosSystem {
      specialArgs = {
        flake = self;   
      };

      modules = [ 
        inputs.ragenix.nixosModules.default

        mainModule  
      ];
    }) {
      nixos = ./host-nixos.nix;
      hoas = ./host-hoas.nix;
    };
   
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        age
        ragenix
      ];
    };
  };
}

