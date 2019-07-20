data "template_cloudinit_config" "user_data" {
	gzip = false
  base64_encode = false
	part {
		content_type = "text/cloud-config"
		content = <<EOF
#cloud-config
# vim: syntax=yaml

hostname: "${element(random_pet.zoo.*.id, count.index)}"
fqdn: "${element(random_pet.zoo.*.id, count.index)}.example.com"

users:
  - name: root
    ssh_authorized_keys:
      - ${file("~/.ssh/id_rsa.pub")}

ssh_pwauth: True
disable_root: False
chpasswd:
  list: |
    root:password
  expire: False

EOF
	}
	count = "${var.vm_count}"
}

