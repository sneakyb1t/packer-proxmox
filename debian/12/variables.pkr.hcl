variable "proxmox_url" {
  type = string
}

variable "proxmox_node" {
  type = string
}

variable "proxmox_password" {
  type      = string
  sensitive = true
}

variable "proxmox_username" {
  type = string
}

variable "proxmox_insecure" {
  type    = string
  default = true
}

variable "proxmox_vm_id" {
  type    = string
  default = 0
}

variable "proxmox_datastore" {
  type = string
}

variable "proxmox_template_name" {
  type = string
}

variable "proxmox_storage_pool" {
  type = string
}

variable "proxmox_scsi_controller" {
  type    = string
  default = "virtio-scsi-pci"
}

variable "iso_url" {
  type = string
}

variable "boot_wait" {
  type    = string
  default = "15s"
}

variable "vm_username" {
  type      = string
  sensitive = true
  default   = "packer"
}

variable "vm_password" {
  type      = string
  sensitive = true
  default   = "packer"
}

variable "vm_password_encrypted" {
  type      = string
  sensitive = true
  default   = "$5$xwGN5Dp4pJTfUs/4$yxIOrbw/loX7UXVm79VHUi6am150kPaYfEyiTtWLcg7"
}

variable "vm_pubkey" {
  type = string
}

variable "vm_hostname" {
  type = string
  default = "debian11"
}

variable "vm_keyboard_deb" {
  type    = string
  default = "us"
}

variable "vm_language" {
  type    = string
  default = "us"
}

variable "vm_fs_type" {
  type    = string
  default = "ext4"
}

variable "vm_timezone" {
  type    = string
  default = "America/Los_Angeles"
}

variable "vm_locale" {
  type    = string
  default = "en_US.UTF-8"
}

variable "vm_country" {
  type    = string
  default = "US"
}

variable "vm_memory" {
  type    = number
  default = 2048
}

variable "vm_disk_size" {
  type    = string
  default = "15360M"
}

variable "vm_disk_type" {
  type    = string
  default = "virtio"
}

variable "vm_net_iface_type" {
  type    = string
  default = "virtio"
}

variable "vm_net_bridge_name" {
  type    = string
  default = "vmbr0"
}

variable "vm_net_firewall" {
  type    = bool
  default = true
}

// Partitioning
variable "vm_part_efi_size" {
  type    = number
  default = 100
}

variable "vm_part_boot_size" {
  type    = number
  default = 824
}

variable "vm_part_root_size" {
  type    = number
  default = 2048
}

variable "vm_part_tmp_size" {
  type    = number
  default = 1024
}

variable "vm_part_var_size" {
  type    = number
  default = 2048
}

variable "vm_part_log_size" {
  type    = number
  default = 2048
}

variable "vm_part_swap_size" {
  type    = number
  default = 1024
}

variable "vm_part_usr_size" {
  type    = number
  default = 6144
}

variable "vm_sockets" {
  type    = string
  default = "1"
}

variable "vm_cores" {
  type    = string
  default = "1"
}

variable "vm_cpu_type" {
  type    = string
  default = "host"
}

variable "vm_os" {
  type    = string
  default = "l26"
}

variable "ssh_private_key" {
  type    = string
  default = "~/.ssh/id_rsa"
}

variable "timeout" {
  type    = string
  default = "30m"
}
variable "iso_checksum" {
  type    = string
}