{config, lib, ...}:

{
boot.kernel.sysctl = { 
	"vm.swappiness" = 25;

	"kernel.kptr_restrict" = 2;
	"kernel.unprivileged_bpf_disabled" = 1;
	"fs.protected_regular" = 2;
	"fs.protected_fifos" = 2;
	"fs.suid_dumpable" = 0;
	"fs.protected_symlinks" = 1;
	"fs.protected_hardlinks" = 1;

	"net.ipv4.conf.all.rp_filter" = 1;
	"net.ipv4.conf.all.accept_redirects" = 0;
	"net.ipv4.conf.all.log_martians" = 1;
	
	"net.ipv4.conf.default.rp_filter" = 1;
	"net.ipv4.conf.default.accept_redirects" = 0;
	"net.ipv4.conf.default.log_martians" = 1;

	"net.ipv6.conf.all.accept_redirects" = 0;
	"net.ipv6.conf.default.accept_redirects" = 0;
	"net.ipv6.conf.all.log_martians" = 1;
	
	"dev.tty.ldisc_autoload" = 0;
	"kernel.sysrq" = 64;
};




}
