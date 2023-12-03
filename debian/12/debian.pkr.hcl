source "proxmox-iso" "debian12" {
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
  boot_wait = var.boot_wait
  disks {
    type              = var.vm_disk_type
    disk_size         = var.vm_disk_size
    storage_pool      = var.proxmox_storage_pool
  }
  efi_config {
    efi_storage_pool  = var.proxmox_storage_pool
    pre_enrolled_keys = true
    efi_type          = "4m"
  }

  scsi_controller          = var.proxmox_scsi_controller
  insecure_skip_tls_verify = var.proxmox_insecure
  iso_url                  = var.iso_url
  iso_storage_pool         = var.proxmox_storage_pool
  iso_checksum             = var.iso_checksum
  os                       = var.vm_os
  cpu_type                 = var.vm_cpu_type
  cores                    = var.vm_cores
  sockets                  = var.vm_sockets
  memory                   = var.vm_memory
  cloud_init               = true
  cloud_init_storage_pool  = var.proxmox_storage_pool

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
    "/ks.cfg" = templatefile("${abspath(path.root)}/http/ks.pkrtpl.hcl", {
      vm_username           = var.vm_username
      vm_password           = var.vm_password
      vm_password_encrypted = var.vm_password_encrypted
      vm_pubkey             = var.vm_pubkey
      vm_language           = var.vm_language
      vm_keyboard           = var.vm_keyboard_deb
      vm_timezone           = var.vm_timezone
      vm_locale             = var.vm_locale
      vm_country            = var.vm_country
      vm_disk_type          = var.vm_disk_type
      vm_fs_type            = var.vm_fs_type
      vm_hostname           = var.vm_hostname
      vm_part_efi_size      = var.vm_part_efi_size
      vm_part_boot_size     = var.vm_part_boot_size
      vm_part_root_size     = var.vm_part_root_size
      vm_part_tmp_size      = var.vm_part_tmp_size
      vm_part_var_size      = var.vm_part_var_size
      vm_part_log_size      = var.vm_part_log_size
      vm_part_home_size     = var.vm_part_home_size
      vm_part_usr_size      = var.vm_part_usr_size
      vm_part_swap_size     = var.vm_part_swap_size
    })
  }
}

build {
  sources = ["source.proxmox-iso.debian12"]
  provisioner "shell" {
    remote_folder = "~"
    inline        = ["sudo apt-get update -y"," sudo apt-get upgrade -y", "sudo apt install ansible git -y" ]
  }
  provisioner "ansible-local" {
  playbook_file = "site.yml"
  role_paths = ["roles"]
  extra_arguments = [
    "--extra-vars",
    "ANSIBLE_BECOME_PASS=${var.vm_password} openscap_hardening=${var.openscap_hardening}"
    ]
  }
  provisioner "shell" {
    remote_folder = "~"
    inline        = ["echo ${var.vm_password} |sudo -S apt remove ansible -y"]
  }
}
