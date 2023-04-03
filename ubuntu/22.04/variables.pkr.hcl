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
  default = false
}

variable "proxmox_vm_id" {
  type = string
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

variable "proxmox_storage_pool_type" {
  type    = string
  default = "lvm"
}

variable "proxmox_scsi_controller" {
  type    = string
  default = "virtio-scsi-pci"
}

variable "iso_file" {
  type = string
}

variable "build_username" {
  type    = string
  sensitive = true
  default = "packer"
}

variable "build_password" {
  type      = string
  sensitive = true
  default   = "packer"
}

variable "build_password_encrypted" {
  type      = string
  sensitive = true
  default   = "$5$xwGN5Dp4pJTfUs/4$yxIOrbw/loX7UXVm79VHUi6am150kPaYfEyiTtWLcg7"
}

// VM vars
variable "vm_keyboard" {
  type    = string
  default = "us"
}

variable "vm_hostname" {
  type = string
}

variable "vm_fstype" {
  type    = string
  default = "ext4"
}

variable "vm_timezone" {
  type    = string
  default = "en_US"
}

variable "vm_memory" {
  type = number
}

variable "vm_disk_size" {
  type = string
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
