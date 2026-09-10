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


];

boot.extraModulePackages = [ ];




}
