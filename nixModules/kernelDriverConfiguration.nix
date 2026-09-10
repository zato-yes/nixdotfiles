{config, lib, ...}:

{

boot.initrd.availableKernelModules = [ 
	"xhci_pci" 
	"ahci" 
	"nvme"
	"evdev"
	"ext4"
	"dm_mod"
	"efivarfs"
];

boot.initrd.kernelModules = [ ];

boot.kernelModules = [ 
	"kvm-intel"
	"usb_storage"
	"uas"
	"sd_mod"
	"snd_usb_audio"
	"snd_ump"
	"cdc_ether"
	"usbnet"
	"mii"
	"r8152"



];

boot.extraModulePackages = [ ];




}
