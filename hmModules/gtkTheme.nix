{ pkgs, ... }:
{
	gtk = {
		enable = true;
		colorScheme = "dark";
		iconTheme = {
			name = "Papirus-Dark";
			package = pkgs.catppuccin-papirus-folders.override {
			flavor = "mocha";
			accent = "mauve";
			};
		};
	};
}
