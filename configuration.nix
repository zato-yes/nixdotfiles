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
programs.mangowc.enable = true;

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
    alacritty 
    fastfetch 
    neovim 
    htop 
    grim 
    slurp 
    rofi 
    scrcpy 
    lzip 
    obs-studio 
    wl-clipboard 
    pavucontrol 
    brightnessctl 
    wev
    foot
    mangowc 
    macchanger 
    waybar 
    git 
    lm_sensors 
    bibata-cursors
    #librewolf
    pkgsUnstable.firefox

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
RemainAfterExit = true;
};
};

boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
boot.kernelModules = [ "v4l2loopback" ];
boot.extraModprobeConfig = ''
options v4l2loopback devices=1 video_nr=10 card_label="OBS Virtual Camera" exclusive_caps=1
'';

system.stateVersion = "25.11";
}
