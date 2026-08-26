{ config, lib, pkgs, pkgsUnstable, ... }:
{
imports = [ ./hardware-configuration.nix ];

boot.loader = {
  grub = {
	enable = true;
	#consoleMode = "max";
	#configurationLimit = 10;
	device = "nodev";
	efiSupport = true;
	useOSProber = false;
  };
	efi.canTouchEfiVariables = true;
	efi.efiSysMountPoint = "/boot/efi";

};

#boot.lanzaboote = {
#	enable = false;
#	pkiBundle = "/var/lib/sbctl";
#};
boot.loader.grub.extraEntries = ''
  submenu 'Brunch' {
    menuentry 'Brunch' --class 'brunch' {
      rmmod tpm
      unset theme
      img_path="/Brunch.img"
      img_uuid="3bdee200-ba3c-43d8-bc04-8540803039db"
      search --no-floppy --set=root --file ''${img_path}
      loopback loop ''${img_path}
      source (loop,12)/efi/boot/settings.cfg
      if [ -z ''${verbose} ] -o [ ''${verbose} -eq 0 ]; then
        linux (loop,7)''${kernel} boot=local noresume noswap loglevel=7 options=''${options} chromeos_bootsplash=''${chromeos_bootsplash} ''${cmdline_params} \
          cros_secure cros_debug img_uuid=''${img_uuid} img_path=''${img_path} \
          console= vt.global_cursor_default=0 brunch_bootsplash=''${brunch_bootsplash} quiet
      else
        linux (loop,7)''${kernel} boot=local noresume noswap loglevel=7 options=''${options} chromeos_bootsplash=''${chromeos_bootsplash} ''${cmdline_params} \
          cros_secure cros_debug img_uuid=''${img_uuid} img_path=''${img_path}
      fi
      initrd (loop,7)/lib/firmware/amd-ucode.img (loop,7)/lib/firmware/intel-ucode.img (loop,7)/initramfs.img
    }
    menuentry 'Brunch settings' --class 'brunch-settings' {
      rmmod tpm
      unset theme
      img_path="/Brunch.img"
      img_uuid="3bdee200-ba3c-43d8-bc04-8540803039db"
      search --no-floppy --set=root --file ''${img_path}
      loopback loop ''${img_path}
      source (loop,12)/efi/boot/settings.cfg
      linux (loop,7)/kernel boot=local noresume noswap loglevel=7 options= chromeos_bootsplash= edit_brunch_config=1 \
        cros_secure cros_debug img_uuid=''${img_uuid} img_path=''${img_path}
      initrd (loop,7)/lib/firmware/amd-ucode.img (loop,7)/lib/firmware/intel-ucode.img (loop,7)/initramfs.img
    }
  }
'';


boot.kernelPackages = pkgs.linuxPackages_latest;
services.fwupd.enable = true;
hardware.cpu.intel.updateMicrocode = true;
hardware.enableRedistributableFirmware = true;
hardware.graphics.enable = true;
hardware.graphics.enable32Bit = true;

nix.settings.experimental-features = [ "nix-command" "flakes"];
networking.hostName = "sweetNix";
networking.networkmanager.enable = true;
time.timeZone = "Europe/Berlin";
console.keyMap = "uk";
i18n.defaultLocale = "en_US.UTF-8";
networking.nftables.enable = true;

services.pipewire = {
    enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
};

users.users.dummy = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [ tree ];
};


security.polkit.enable = true;

services.displayManager.ly = {
    enable = true;
	settings = {
		setup_cmd = "";
	};
};

services.upower.enable = true;
programs.dconf.enable = true;
#####


fonts.packages = with pkgs; [
  nerd-fonts.jetbrains-mono
(iosevka-bin.override { variant = "SGr-IosevkaFixed"; })
];
# Apps
environment.systemPackages = with pkgs; [
    vim
    neovim
    wget 
    htop 
    grim 
	fwupd
    slurp 
    rofi 
	python3
	sbctl
	scrcpy 
    wl-clipboard 
	pkgsUnstable.steam
	heroic
    pavucontrol 
    brightnessctl 
    wev
    foot
	gsettings-desktop-schemas
    macchanger 
	swayidle
    git 
	thunar
	ly
	jetbrains-mono
    lm_sensors 
	input-remapper
	dconf
	glib
    bibata-cursors
	pkgs.vimPlugins.cmp-nvim-lsp
    pkgs.vimPlugins.nvim-cmp
    nixd
	quickshell
    lua-language-server
];

services.flatpak.enable = true;
xdg.portal.enable = true;
xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
#





#Services
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

environment.sessionVariables = {
  WLR_DRM_NO_ATOMIC = "1";
  XDG_DATA_DIRS = [
    "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
  ];
};

services.thermald.enable = true;

systemd.services.battery-charge-limit = {
description = "set battery charge 60%";
wantedBy = [ "multi-user.target" ];
serviceConfig = {
Type = "oneshot";
ExecStart = "${pkgs.bash}/bin/sh -c 'echo 60 > /sys/class/power_supply/BAT0/charge_control_end_threshold'";
RemainAfterExit = false;
};
};


system.stateVersion = "25.11";
}
