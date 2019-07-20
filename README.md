# terraform_libvirt

[![GitHub releases](https://img.shields.io/github/release/satandyh/terraform_libvirt.svg)](https://github.com/satandyh/terraform_libvirt/releases)

This repo creates some count of centos7-cloud VMs.  
Main purpose were test and learn terraform.

# inside

- **`vm_count = 3`** - count of VMs by default
- **hostname** - every time new because I used random for it
- **network ip** - now it uses dhcp for single eth0 interface; static configuration also may be used for it, but for me it were useless
- **`ssh root@ip`** - connection to VM with your key (it automaticaly put it inside all newly created VMs) or You can use `root/password` credentials instead

PS  
All vms will have name in ubuntu style (two words one of which is animal name).
