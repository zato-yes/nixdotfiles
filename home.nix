{ config, pkgs, ... }:

let
	dotfiles = "${config.home.homeDirectory}/nixdotfiles/config";
	createSymlink = path: config.lib.file.mkOutOfStoreSymlink path;
	configs = {
		mango = "mango";
		nvim = "nvim";
		quickshell = "quickshell";
	};
in

{


  imports = [
  	./hmModules/bash.nix
  	./hmModules/firefox.nix
  	./hmModules/papirusicons.nix
  ];

	home.username = "dummy";
    home.homeDirectory = "/home/dummy";
    home.stateVersion = "26.05";


xdg.configFile = builtins.mapAttrs
	(name: subpath: {
		source = createSymlink "${dotfiles}/${subpath}";
		recursive = true;
	})
	configs;














}

