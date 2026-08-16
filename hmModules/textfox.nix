{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.textfox.homeManagerModules.default
  ];

  textfox = {
    enable = true;
    profiles = [ "default" ];
    config = {
      background = {
        color = "#1b1e25";
      };
      border = {
        color = "#717787"; # unfocused color
        width = "1px";
        transition = "1.0s ease";
        radius = "5px";
      };
      displayWindowControls = true;
      displayNavButtons = true;
      displayUrlbarIcons = true;
      displaySidebarTools = false;
      displayTitles = false;
      font = {
        family = "JetBrains Mono";
        size = "15px";
        accent = "#c6c6c8"; # focused color
      };
      tabs = {
        horizontal.enable = true;
        vertical.enable = true;
      };
      navbar = {
        margin = "3px 3px 8px";
        padding = "4px";
      };
      bookmarks = {
        alignment = "left";
      };
      icons = {
        toolbar.extensions.enable = true;
        context.extensions.enable = true;
        context.firefox.enable = true;
      };
      textTransform = "lowercase";
      extraConfig = "/* custom css here */";
    };
  };
}
