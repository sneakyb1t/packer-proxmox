source "proxmox" "coreos" {
  boot_wait    = "10s"
  boot_command = ["<up>e<down><down><end> ignition.config.url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/installer.ign<leftCtrlOn>x<leftCtrlOff>"]
  http_directory = "./coreos/38/config"

  # load template ignition file
  additional_iso_files {
    cd_files = ["./coreos/38/config/template.ign"]
    iso_storage_pool = "local"
    unmount = true
  }
  efi_config {
  efi_storage_pool         = var.proxmox_storage_pool
  pre_enrolled_keys        = true
  efi_type                 = "4m"
  }

  # CoreOS does not support CloudInit
  cloud_init = false
  qemu_agent = true

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

  ssh_private_key_file = "~/.ssh/id_rsa_personal-internal_ansible"
}

build {
  sources = ["source.proxmox.coreos"]
  provisioner "shell" {
    inline = [
      "sudo mkdir /tmp/iso",
      "sudo mount /dev/sr1 /tmp/iso -o ro",
      "sudo coreos-installer install /dev/vda --ignition-file /tmp/iso/installer.ign",
    ]
  }
}

