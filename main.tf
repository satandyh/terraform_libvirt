# choose version
terraform {
  required_version = ">= 0.12"
}

# use localhost kvm
provider "libvirt" {
  uri = "qemu:///system"
}

# create random id for naming
resource "random_id" "rndid" {
  prefix      = "centos8-"
  byte_length = 2
  count       = "${var.vm_count}"
}

# create volumes
resource "libvirt_volume" "rh" {
  #source = "https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-GenericCloud-8.1.1911-20200113.3.x86_64.qcow2"
  source = "/var/lib/libvirt/images/CentOS-8-GenericCloud-8.1.1911-20200113.3.x86_64.qcow2"
  format = "qcow2"
  name   = "${element(random_id.rndid.*.hex, count.index)}.qcow2"
  pool   = "default"
  count  = "${var.vm_count}"
}

# create minidisk for first boot configuration
resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "${element(random_id.rndid.*.hex, count.index)}_init.iso"
  user_data = "${element(data.template_cloudinit_config.user_data.*.rendered, count.index)}"
  #network_config = "${element(data.template_cloudinit_config.network_config.*.rendered, count.index)}"
  count = "${var.vm_count}"
}

# create VM
resource "libvirt_domain" "rh" {
  #domaintype = "qemu"
  name      = "${element(random_id.rndid.*.hex, count.index)}"
  cloudinit = "${element(libvirt_cloudinit_disk.commoninit.*.id, count.index)}"
  cpu = {
    mode = "host-passthrough"
  }
  vcpu   = "2"
  memory = "2048"
  network_interface {
    network_name   = "default"
    wait_for_lease = "true"
  }
  disk {
    volume_id = "${element(libvirt_volume.rh.*.id, count.index)}"
    #scsi      = "true"
  }
  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }
  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }
  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
  count = "${var.vm_count}"
}
