{config, lib, ...}:

{

boot.blacklistedKernelModules = [ 
"sctp"
"dccp"
"rds"
"tipc"
"joydev"
];



}
