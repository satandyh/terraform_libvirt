# just get some ip

output "vm" {
  value = "${libvirt_domain.rh.*.name}"
}

output "ip" {
  value = "${libvirt_domain.rh.*.network_interface.0.addresses}"
}
