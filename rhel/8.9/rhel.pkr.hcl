source "proxmox-iso" "rhel8" {
  boot_command = ["e<down><down><end><bs><bs><bs><bs><bs>inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/inst.ks<leftCtrlOn>x<leftCtrlOff>"]
  boot_wait    = var.boot_wait
  disks {
    type              = var.vm_disk_type
    disk_size         = var.vm_disk_size
    storage_pool      = var.proxmox_storage_pool
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
    "/inst.ks" = templatefile("${abspath(path.root)}/http/inst.ks.hcl", {
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
  sources = ["source.proxmox-iso.rhel8"]
  provisioner "shell" {
    remote_folder = "~"
    inline = ["sudo subscription-manager register --username ${var.redhat_subscription_username} --password ${var.redhat_subscription_password}"]
  }
  provisioner "shell" {
    inline = ["sudo subscription-manager repos --enable codeready-builder-for-rhel-9-$(arch)-rpms &&  sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && sudo dnf install ansible -y "]
  }
  provisioner "ansible-local" {
  playbook_file = "site.yml"
  role_paths = ["roles"]
  extra_arguments = [
    "--extra-vars",
    "ANSIBLE_BECOME_PASS=${var.vm_password}"
    ]

  }
  provisioner "shell" {
    remote_folder = "~"
    inline        = ["echo ${var.vm_password} |sudo -S yum remove ansible -y"]
  }

}