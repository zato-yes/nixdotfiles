{config, pkgs, ...}:
{



programs.bash = {
	enable = true;
	shellAliases = { 
		nrs = "sudo nixos-rebuild switch --flake ~/nixdotfiles#sweetNix";


	};
};




}
