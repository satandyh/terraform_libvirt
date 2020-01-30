data "template_cloudinit_config" "network_config" {
  gzip          = false
  base64_encode = false
  part {
    content_type = "text/cloud-config"
    content      = <<EOF
#cloud-config
# vim: syntax=yaml

network:
	version: 2
	ethernets:
		eth:
		  match:
			  name: eth0
			dhcp4: true
			dhcp6: true
			nameservers:
				search: [example.com]
				addresses: [1.1.1.1]
EOF
  }
  count = "${var.vm_count}"
}
