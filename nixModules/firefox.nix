{config, pkgs, ...}:


{

programs.firefox = {
	policies = {
		ExtensionSettings = {
			"uBlock0@raymondhill.net" = {
			install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
			installation_mode = "normal_installed";
			};
		};
	};
};





}
