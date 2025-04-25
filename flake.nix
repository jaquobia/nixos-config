{
	description = "Quiba's NixOS system configuration";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
	};

	outputs = { self, nixpkgs, ... }@inputs: {
		nixosConfigurations.quiba-nixos = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [
				#Import old configuration so system does not change
				/etc/nixos/configuration.nix
			];
		};
	};
}
