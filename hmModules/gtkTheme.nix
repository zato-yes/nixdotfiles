{ pkgs, ... }:
{
	gtk.enable = true;
	gtk.colorScheme = "dark";
	gtk.iconTheme = {
    	name = "Papirus-Dark";
    	package = pkgs.catppuccin-papirus-folders.override {
     	flavor = "mocha";
      	accent = "mauve";
    };







  };
}
