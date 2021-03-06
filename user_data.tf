data "template_cloudinit_config" "user_data" {
  gzip          = false
  base64_encode = false
  part {
    content_type = "text/cloud-config"
    content      = <<EOF
#cloud-config
# vim: syntax=yaml

hostname: "${element(random_id.rndid.*.hex, count.index)}"
fqdn: "${element(random_id.rndid.*.hex, count.index)}.example.com"

users:
  - name: root
    ssh_authorized_keys:
      - ${file("~/.ssh/id_ed25519.pub")}
  - name: user
    ssh_authorized_keys:
      - ${file("~/.ssh/id_ed25519.pub")}

ssh_pwauth: True
disable_root: False
chpasswd:
  list: |
    root:password
    user:password
  expire: False

EOF
  }
  count = "${var.vm_count}"
}
