# just get some ip

output "vm" {
  value = libvirt_domain.centos7.*.name
}

output "ip" {
  value = libvirt_domain.centos7.*.network_interface.0.addresses
}
