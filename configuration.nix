{ config, lib, pkgs, pkgsUnstable, ... }:

{
imports = [ ./hardware-configuration.nix ];
boot.loader = {
  grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
  };
  efi.canTouchEfiVariables = true;
};

boot.loader.grub.extraEntries = ''
  submenu 'Brunch' {
    menuentry 'Brunch' --class 'brunch' {
      rmmod tpm
      unset theme
      img_path="/Brunch.img"
      img_uuid="2abc6672-4688-409a-be9f-c3837506a5f9"
      search --no-floppy --set=root --file ''${img_path}
      loopback loop ''${img_path}
      source (loop,12)/efi/boot/settings.cfg
      if [ -z ''${verbose} ] -o [ ''${verbose} -eq 0 ]; then
        linux (loop,7)''${kernel} boot=local noresume noswap loglevel=7 options=''${options} \
          cros_secure cros_debug img_uuid=''${img_uuid} img_path=''${img_path} \
          console= vt.global_cursor_default=0 brunch_bootsplash=''${brunch_bootsplash} quiet
      else
        linux (loop,7)''${kernel} boot=local noresume noswap loglevel=7 options=''${options} \
          cros_secure cros_debug img_uuid=''${img_uuid} img_path=''${img_path}
      fi
      initrd (loop,7)/lib/firmware/amd-ucode.img (loop,7)/lib/firmware/intel-ucode.img (loop,7)/initramfs.img
    }
    menuentry 'Brunch settings' --class 'brunch-settings' {
      rmmod tpm
      unset theme
      img_path="/Brunch.img"
      img_uuid="2abc6672-4688-409a-be9f-c3837506a5f9"
      search --no-floppy --set=root --file ''${img_path}
      loopback loop ''${img_path}
      source (loop,12)/efi/boot/settings.cfg
      linux (loop,7)/kernel boot=local noresume noswap loglevel=7 options= chromeos_bootsplash= \
        edit_brunch_config=1 cros_secure cros_debug img_uuid=''${img_uuid} img_path=''${img_path}
      initrd (loop,7)/lib/firmware/amd-ucode.img (loop,7)/lib/firmware/intel-ucode.img (loop,7)/initramfs.img
    }
  }
'';

boot.loader.systemd-boot.enable = false;
boot.loader.efi.efiSysMountPoint = "/boot/efi";
boot.loader.grub.useOSProber = true;
boot.kernelPackages = pkgs.linuxPackages_latest;

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


# hyprland+displaymanager
security.polkit.enable = true;

services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
};



#####

fonts.packages = with pkgs; [
(iosevka-bin.override { variant = "SGr-IosevkaFixed"; })
];


# Apps
environment.systemPackages = with pkgs; [
    vim
    neovim
    wget 
    htop 
    grim 
    slurp 
    rofi 
    scrcpy 
    wl-clipboard 
    pavucontrol 
    brightnessctl 
    wev
    foot
    mangowc 
    macchanger 
    git 
    thunar
    lm_sensors 
    bibata-cursors
	pkgs.vimPlugins.cmp-nvim-lsp
    pkgs.vimPlugins.nvim-cmp
    nixd
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
ExecStartPre = "${pkgs.coreutils}/bin/sleep 3";
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
