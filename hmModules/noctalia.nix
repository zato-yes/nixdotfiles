{config, inputs, ...}:

{
imports = [
      inputs.noctalia.homeModules.default
	];


programs.noctalia = {
	enable = true;
	settings = ../config/noctalia/settings.toml; 
};
}
