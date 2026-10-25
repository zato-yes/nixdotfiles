{config, inputs, ...}:

{
imports = [
      inputs.noctalia.homeModules.default
	];


programs.noctalia = {
	enable = true;
	settings = "~/nixdotfiles/config/noctalia/settings.toml";
};
}
