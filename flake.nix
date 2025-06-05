{
	description = "Quiba's NixOS system configuration";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
		unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
		quiba-pkgs = {
			url = "github:Jaquobia/quibundles-nix/";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		aagl = {
			url = "github:ezKEa/aagl-gtk-on-nix/release-25.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, unstable, aagl, ... }@inputs: 
	let
	system = "x86_64-linux";
	pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
	# pkgs = nixpkgs.legacyPackages.${system};
	# quiba-pkgs = inputs.quiba-pkgs.packages.${system};
	quiba-pkgs = pkgs.callPackage inputs.quiba-pkgs { };
	quib-overlay = (final: prev: { quiba = quiba-pkgs; });
	unstable-overlay = (final: prev: { unstable = import unstable { inherit system; config = { allowUnfree = true; permittedInsecurePackages = [ "dotnet-runtime-7.0.20" ]; }; }; });
	in
	{
		nixosConfigurations.quiba-nixos = nixpkgs.lib.nixosSystem {
			specialArgs = {
				# unstable = import unstable { inherit system; config = { allowUnfree = true; permittedInsecurePackages = [ "dotnet-runtime-7.0.20" ]; }; };
				# quiba-pkgs = import inputs.quiba-pkgs { inherit system pkgs; };
				# inherit quiba-pkgs;
			};
			modules = [
				{
					nixpkgs.overlays = [
						quib-overlay
						unstable-overlay
					];
				}
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
