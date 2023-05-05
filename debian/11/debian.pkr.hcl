source "proxmox" "debian11" {
  boot_command = [
    "<wait3s>c<wait3s>",
    "linux /install.amd/vmlinuz",
    " auto-install/enable=true",
    " debconf/priority=critical",
    " url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg",
    " noprompt --<enter>",
    "initrd /install.amd/initrd.gz<enter>",
    "boot<enter>",
    "<wait30s>",
    "<enter><wait>",
    "<enter><wait>",
    "<leftAltOn><f2><leftAltOff>",
    "<enter><wait>",
    "mount /dev/sr1 /media<enter>",
    "<leftAltOn><f1><leftAltOff>",
    "<down><down><down><down><enter>"
  ]
  boot_wait = "10s"
  disks {
    type              = var.vm_disk_type
    disk_size         = var.vm_disk_size
    storage_pool      = var.proxmox_storage_pool
    storage_pool_type = var.proxmox_storage_pool_type
  }
  efi_config {
    efi_storage_pool         = var.proxmox_storage_pool
    pre_enrolled_keys        = true
    efi_type                 = "4m"
  }
  scsi_controller          = var.proxmox_scsi_controller
  insecure_skip_tls_verify = var.proxmox_insecure
  iso_file                 = "${var.proxmox_datastore}:iso/${var.iso_file}"
  os		           = var.vm_os
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
  ssh_timeout   = "30m"
  ssh_username  = var.vm_username
  template_name = var.proxmox_template_name
  unmount_iso   = true
  username      = var.proxmox_username
  vm_id         = var.proxmox_vm_id
  bios          = "ovmf"
  http_content = {
    "/ks.cfg" = templatefile("${abspath(path.root)}/http/ks.pkrtpl.hcl", {
      vm_username			   = var.vm_username
      vm_password              = var.vm_password
      vm_password_encrypted    = var.vm_password_encrypted
      vm_pubkey                = var.vm_pubkey
      vm_language              = var.vm_timezone
      vm_keyboard              = var.vm_keyboard
      vm_timezone              = var.vm_timezone
      vm_fs_type               = var.vm_fs_type
      vm_hostname              = var.vm_hostname
      vm_part_efi_size         = var.vm_part_efi_size
      vm_part_boot_size        = var.vm_part_boot_size
      vm_part_root_size        = var.vm_part_root_size
      vm_part_tmp_size         = var.vm_part_tmp_size
      vm_part_var_size         = var.vm_part_var_size
      vm_part_log_size         = var.vm_part_log_size
      vm_part_usr_size         = var.vm_part_usr_size
    })
  }
}

build {
  sources = ["source.proxmox.debian11"]

  provisioner "shell" {
    remote_folder = "/home/${var.vm_username}"
    inline = ["sudo apt-get update", "sudo apt-get upgrade -y"]
  }
}
