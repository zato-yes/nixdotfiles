{config, lib, ...}:

{

boot.blacklistedKernelModules = [ 
"sctp"
"dccp"
"rds"
"tipc"
"hid_multitouch"
"joydev"
];



}
