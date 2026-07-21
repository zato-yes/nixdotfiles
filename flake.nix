{
    description = "sweetNix flake";
    inputs = {
    	nixpkgs.url = "nixpkgs/nixos-26.05";
		nixpkgsUnstable.url = "nixpkgs/nixos-unstable";
    	home-manager = {
	   		url = "github:nix-community/home-manager/release-26.05";
	   		inputs.nixpkgs.follows = "nixpkgs";
		};
		mangowm = {
			url = "github:mangowm/mango";
			inputs.nixpkgs.follows = "nixpkgsUnstable";
		};
	





	
	};
    outputs = { self, nixpkgs, home-manager, nixpkgsUnstable, mangowm, ...}@inputs:
    let
	system = "x86_64-linux";
       pkgsUnstable = import nixpkgsUnstable { inherit system; config.allowUnfree = true; };
    in

    {
	nixosConfigurations.sweetNix = nixpkgs.lib.nixosSystem {
	    inherit system;
	    specialArgs = { inherit pkgsUnstable mangowm;};
	    modules = [
		./configuration.nix
		home-manager.nixosModules.home-manager
		mangowm.nixosModules.mango
		{
		    home-manager = {
			useGlobalPkgs = true;
			useUserPackages = true;
			users.dummy = import ./home.nix;
			backupFileExtension = "backup";
			extraSpecialArgs = { inherit pkgsUnstable;};
		    };
		}
	    ];
	};
    };
}
