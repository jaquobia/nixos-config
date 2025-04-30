{
	description = "Quiba's NixOS system configuration";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
		unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
		quiba-pkgs.url = "github:jaquobia/quibundles-nix";
		aagl = {
			url = "github:ezKEa/aagl-gtk-on-nix/release-24.11";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, unstable, aagl, ... }@inputs: {
		nixosConfigurations.quiba-nixos = nixpkgs.lib.nixosSystem rec {
			system = "x86_64-linux";
			specialArgs = {
				unstable = import unstable { inherit system; };
				quiba-pkgs = import inputs.quiba-pkgs { inherit system; };
			};
			modules = [
				#Import old configuration so system does not change
				./configuration.nix
				{
					imports = [ aagl.nixosModules.default ];
					nix.settings = aagl.nixConfig; # Set up Cachix
					programs.anime-game-launcher.enable = true;
					programs.honkers-railway-launcher.enable = true;
				}
			];
		};
	};
}
