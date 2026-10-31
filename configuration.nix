{ config, lib, pkgs, pkgsUnstable, ... }:
{
nix.settings.experimental-features = [ "nix-command" "flakes"];
boot.kernelPackages = pkgs.linuxPackages_latest;
imports = [ 
	./hardware-configuration.nix
	./nixModules/blackListedKernelModules.nix
	./nixModules/kernelDriverConfiguration.nix
	./nixServices/services.nix
	./nixModules/sysctlConfiguration.nix
];
security.lockKernelModules = true;
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
      img_uuid="5f7d8435-d737-4cd2-a6d1-3bb41ef0b652"
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
      img_uuid="5f7d8435-d737-4cd2-a6d1-3bb41ef0b652"
      search --no-floppy --set=root --file ''${img_path}
      loopback loop ''${img_path}
      source (loop,12)/efi/boot/settings.cfg
      linux (loop,7)/kernel boot=local noresume noswap loglevel=7 options= chromeos_bootsplash= edit_brunch_config=1 \
        cros_secure cros_debug img_uuid=''${img_uuid} img_path=''${img_path}
      initrd (loop,7)/lib/firmware/amd-ucode.img (loop,7)/lib/firmware/intel-ucode.img (loop,7)/initramfs.img
    }
  }
'';


hardware = {
	cpu.intel.updateMicrocode = true;
	enableRedistributableFirmware = true;
	graphics.enable = true;
	graphics.enable32Bit = true;
};

programs.ydotool.enable = true;
time.timeZone = "Europe/Berlin";
console.keyMap = "uk";
i18n.defaultLocale = "en_US.UTF-8";
networking = {
	nftables.enable = true;
	networkmanager.enable = true;
	hostName = "sweetNix";
};

users.users.dummy = {
    isNormalUser = true;
    extraGroups = [ "wheel" "ydotool" ];
    packages = with pkgs; [ tree ];
};

fonts.packages = with pkgs; [
  nerd-fonts.jetbrains-mono
];

environment.systemPackages = with pkgs; [
    vim
    neovim
    wget 
    htop 
    grim 
    slurp 
	sbctl
	scrcpy 
    wl-clipboard 
	satty
	pkgsUnstable.steam
    pavucontrol 
    brightnessctl 
    wev
	fuzzel
    foot
	gsettings-desktop-schemas
	thunar
    lm_sensors 
	input-remapper
	dconf
	glib
    bibata-cursors
	vimPlugins.cmp-nvim-lsp
    vimPlugins.nvim-cmp
    nixd
    lua-language-server
];



system.stateVersion = "25.11";
}
