source "proxmox-iso" "ubuntu22" {
  boot_command = ["c",
    "<wait><wait><wait>linux /casper/vmlinuz --- autoinstall ds='nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/'",
    "<enter><wait>",
  "<wait><wait><wait>initrd /casper/initrd<enter><wait>", "<wait>boot<enter>"]
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
  ssh_timeout   = var.timeout
  ssh_username  = var.vm_username
  template_name = var.proxmox_template_name
  unmount_iso   = true
  username      = var.proxmox_username
  vm_id         = var.proxmox_vm_id
  bios          = "ovmf"

  http_content = {
    "/meta-data" = file("${abspath(path.root)}/http/meta-data")
    "/user-data" = templatefile("${abspath(path.root)}/http/user-data.pkrtpl.hcl", {
      vm_username              = var.vm_username
      vm_password              = var.vm_password
      vm_password_encrypted    = var.vm_password_encrypted
      vm_pubkey                = var.vm_pubkey
      vm_language              = var.vm_language
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
      vm_swap_size             = var.vm_swap_size
    })
  }
}

build {
  sources = ["source.proxmox-iso.ubuntu22"]

  provisioner "shell" {
    inline = ["while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done", "sudo apt-get update", "sudo apt-get upgrade -y"]
  }
}
