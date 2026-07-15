{ config, pkgs, ... }:

let
	dotfiles = "${config.home.homeDirectory}/nixdotfiles/config";
	createSymlink = path: config.lib.file.mkOutOfStoreSymlink path;
	configs = {
		mango = "mango";
		nvim = "nvim";
	};
in

{


  imports = [
    ./bash.nix
  ];

	home.username = "dummy";
    home.homeDirectory = "/home/dummy";
    home.stateVersion = "26.05";
    	programs.bash = {
			enable = true;
			shellAliases = {
	    	yes = "echo he said yes";
		};
	};


xdg.configFile = builtins.mapAttrs
	(name: subpath: {
		source = createSymlink "${dotfiles}/${subpath}";
		recursive = true;
	})
	configs;














}

