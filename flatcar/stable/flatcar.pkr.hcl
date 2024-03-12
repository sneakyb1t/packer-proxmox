packer {
  required_plugins {
    proxmox = {
      version = ">= 1.1.6"
      source  = "github.com/hashicorp/proxmox"
    }
  }
  required_version = ">= v1.9.4"
}

source "proxmox-iso" "flatcar" {
  boot_wait    = "1m"
  boot_command = [
    "sudo -i<enter>",
    "set -eu<enter>",
    "wget http://{{ .HTTPIP }}:{{ .HTTPPort }}/installer.ign<enter>",
    "time flatcar-install -d /dev/vda -C stable -i installer.ign<enter>",
    "<wait3m>",
    "reboot<enter>"
  ]
  disks {
    type              = var.vm_disk_type
    disk_size         = var.vm_disk_size
    storage_pool      = var.proxmox_storage_pool
  }

  cloud_init = false
  qemu_agent = true

  scsi_controller          = var.proxmox_scsi_controller
  insecure_skip_tls_verify = var.proxmox_insecure
  iso_url                  = var.iso_url
  iso_storage_pool         = var.proxmox_iso_storage
  iso_checksum             = var.iso_checksum
  os		               = var.vm_os
  cpu_type                 = var.vm_cpu_type
  cores                    = var.vm_cores
  sockets                  = var.vm_sockets
  memory                   = var.vm_memory

  network_adapters {
    model    = var.vm_net_iface_type
    bridge   = var.vm_net_bridge_name
    firewall = var.vm_net_firewall
  }
  node          = var.proxmox_node
  password      = var.proxmox_password
  proxmox_url   = var.proxmox_url
  ssh_password  = var.vm_password
  ssh_timeout   = var.timeout
  ssh_username  = "core"
  template_name = var.proxmox_template_name
  unmount_iso   = true
  username      = var.proxmox_username
  vm_id         = var.proxmox_vm_id
  bios          = "seabios"
  ssh_private_key_file = var.ssh_private_key

  http_content = {
    "/installer.ign" = templatefile("${abspath(path.root)}/config/installer.ign.hcl", {
      vm_password    = var.vm_password
      vm_pubkey      = var.vm_pubkey
    })
  }
}

build {
  sources = ["source.proxmox-iso.flatcar"]
  provisioner "shell" {
    inline = [
      "sudo shutdown -h +1"
    ]
  }
}
