source "proxmox" "rocky_template" {
 boot_command = ["<up><tab> text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/inst.ks<wait><enter><wait>"]
  boot_wait    = "10s"
  disks {
    type              = var.vm_disk_type
    disk_size         = var.vm_disk_size
    storage_pool      = var.proxmox_storage_pool
    storage_pool_type = var.proxmox_storage_pool_type
  }
  http_content = {
    "/inst.ks" = templatefile("${abspath(path.root)}/http/inst.ks.hcl", {
      vm_username			   = var.vm_username
      vm_password              = var.vm_password
      vm_password_encrypted    = var.vm_password_encrypted
      vm_pubkey                = var.vm_pubkey
      vm_language              = var.vm_timezone
      vm_keyboard              = var.vm_keyboard
      vm_timezone              = var.vm_timezone
      vm_fs_type               = var.vm_fs_type
      vm_hostname              = var.vm_hostname
      vm_part_boot_size        = var.vm_part_boot_size
      vm_part_root_size        = var.vm_part_root_size
      vm_part_tmp_size         = var.vm_part_tmp_size
      vm_part_var_size         = var.vm_part_var_size
      vm_part_log_size         = var.vm_part_log_size
      vm_part_usr_size         = var.vm_part_usr_size
    })
  }

  insecure_skip_tls_verify = var.proxmox_insecure
  iso_file                 = "${var.proxmox_datastore}:iso/${var.iso_file}"
  os		               = "l26"
  cpu_type                 = "Nehalem"
  cores                    = 2
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
}

build {
  sources = ["source.proxmox.rocky_template"]

  provisioner "shell" {
    inline = ["yum install -y cloud-init qemu-guest-agent cloud-utils-growpart gdisk"]
  }
}
