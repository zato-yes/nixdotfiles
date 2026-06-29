{ config, pkgs, ... }:

{
    home.username = "dummy";
    home.homeDirectory = "/home/dummy";
    home.stateVersion = "26.05";
    programs.bash = {
	enable = true;
	shellAliases = {
	    yes = "echo he said yes";
	};
    };
    



}
