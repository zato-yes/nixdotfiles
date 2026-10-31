{ config, lib, pkgs, ... }:
{

services = {
	upower.enable = true;
	thermald.enable = true;
	tumbler.enable = true; 
	flatpak.enable = true;
};

networking.firewall = {
  enable = true;
  allowedTCPPorts = [ ]; 
  allowedUDPPorts = [ ];
};

services.pipewire = {
    enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
};



security.polkit.enable = true;

services.displayManager.ly = {
    enable = true;
	settings = {
		clear_password = true;
		battery_id = "BAT0";
		bg = "0x001b1e25";
		fg = "0x00c6c6c8";
		setup_cmd = "";
	};
};

xdg.portal = {
	enable = true;
    wlr = {
      enable = true;
      settings.screencast = {
        chooser_type = "dmenu";
		chooser_cmd = "${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt='Share: '";
      };
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
};

nix.gc = {
    automatic = true;
    dates = "weekly";
};


systemd = {
    services.remove-nix-gen = {
        description = "removes every nix generation except for 5 lastest";
        serviceConfig = {
            Type = "oneshot";
            ExecStart = ''
            ${pkgs.nix}/bin/nix-env -p /nix/var/nix/profiles/system --delete-generations +5
            '';
        };
    };
    timers.remove-nix-gen = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
            OnCalendar = "weekly";
            Persistent = true;
        };
    };
};




systemd.services.macchanger = {
	description = "macrandomise";
	after = [ "sys-subsystem-net-devices-enp0s20f0u1.device" ];
	wants = [ "sys-subsystem-net-devices-enp0s20f0u1.device" ];
	before = [ "network.target" ];
	wantedBy = [ "multi-user.target" ];
	path = [ pkgs.iproute2 pkgs.macchanger ];
	serviceConfig = {
		Type = "oneshot";
		ExecStartPre = "${pkgs.coreutils}/bin/sleep 0";
		ExecStart = pkgs.writeShellScript "macchanger-script" ''
			ip link set enp0s20f0u1 down
			macchanger -r enp0s20f0u1
			ip link set enp0s20f0u1 up
		'';
	RemainAfterExit = false;
	};
};


systemd.services.battery-charge-limit = {
	description = "set battery charge 60%";
	wantedBy = [ "multi-user.target" ];
	serviceConfig = {
		Type = "oneshot";
		ExecStart = "${pkgs.bash}/bin/sh -c 'echo 60 > /sys/class/power_supply/BAT0/charge_control_end_threshold'";
		RemainAfterExit = false;
	};
};

}
