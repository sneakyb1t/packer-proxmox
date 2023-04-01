variable "proxmox_url" {
    type = string
}

variable "proxmox_node" {
    type = string
}
variable "proxmox_password" {
  type = string
}
variable "proxmox_username" {
  type = string
}

variable "proxmox_vm_id" {
  type = string
}

variable "proxmox_datastore" {
  type = string
}

variable "proxmox_template_name" {
    type = string
}

variable "iso_file" {
    type = string
}

variable "build_username" {
    type = string
}

variable "build_password" {
    type = string
}

variable "build_password_encrypted" {
    type = string
    sensitive = true
}

// VM vars
variable "vm_guest_os_keyboard" {
    type = string
}

variable "vm_guest_os_hostname" {
    type = string
}

variable "vm_guest_os_fstype" {
    type = string
}

variable "vm_guest_os_timezone" {
    type = string
}
