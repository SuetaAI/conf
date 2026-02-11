{
  description = "SuetaAI System Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    # Correct flake for Niri module
    niri.url = "github:sodiboo/niri-flake";
  };

  outputs = { self, nixpkgs, niri, ... }@inputs: {
    nixosConfigurations.my-machine = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        niri.nixosModules.niri 
      ];
    };
  };
}
