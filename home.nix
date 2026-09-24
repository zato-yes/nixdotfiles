{ config, pkgs, inputs, ... }:

let
	dotfiles = "${config.home.homeDirectory}/nixdotfiles/config";
	createSymlink = path: config.lib.file.mkOutOfStoreSymlink path;
	configs = {
		mango = "mango";
		nvim = "nvim";
		quickshell = "quickshell";
		foot = "foot";
		fuzzel = "fuzzel";
		Thunar = "Thunar";
	};
in

{


  imports = [
  	./hmModules/bash.nix
  	./hmModules/firefox.nix
  	./hmModules/gtkTheme.nix
  	./hmModules/textfox.nix
	./hmModules/git.nix
  ];

	home.username = "dummy";
    home.homeDirectory = "/home/dummy";
    home.stateVersion = "26.05";
	xdg.userDirs = {
		enable = true;
		createDirectories = true;
		pictures = "${config.home.homeDirectory}/pictures";
		desktop = null;
		documents = null;
		music = null;
		projects = null;
		videos = null;
		templates = null;
		publicShare = null;

	};


xdg.configFile = builtins.mapAttrs
	(name: subpath: {
		source = createSymlink "${dotfiles}/${subpath}";
		recursive = true;
	})
	configs;




}

