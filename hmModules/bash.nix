{config, pkgs, ...}:
{



programs.bash = {
	enable = true;
	shellAliases = { 
		nrs = "sudo nixos-rebuild switch --flake ~/nixdotfiles#sweetNix";
		satty_  = "satty --filename";
		ls = "ls -lh --color=auto";

	};
};




}
