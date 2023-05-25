variable "pm_api_url" {
  description = "Proxmox API URL"
  type        = string
}

variable "pm_user" {
  description = "Proxmox User"
  type        = string
}

variable "pm_password" {
  description = "Proxmox Password"
  type        = string
  sensitive   = true
}

variable "lxc_password" {
  description = "LXC User Password"
  type        = string
  sensitive   = true
}

variable "ssh_pub_key" {
  description = "Public SSH key to be added to the LXC container"
  type        = string
}

