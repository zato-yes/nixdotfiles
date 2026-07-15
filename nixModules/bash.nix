{config, pkgs, ...}:
{



programs.bash = {
	enable = true;
	shellAliases = { "wow!!" = "echo amazing words"; ll = "ls -l"; };
};




}
