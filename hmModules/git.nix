{config, lib, pkgs, ...}:

{
programs.git = {
	enable = true;
	settings = {
		user = {
			name = "zato-yes";
			email = "zatoyes@duck.com";
		};
		init.defaultBranch = "main";
	};
};

}
