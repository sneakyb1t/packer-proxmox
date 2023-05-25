terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = ">= 0.13.1"
    }
  }
}
provider "proxmox" {
  pm_api_url = var.pm_api_url
  pm_user = var.pm_user
  pm_password = var.pm_password
  pm_tls_insecure = true
}
resource "proxmox_lxc" "ubuntu_lxc" {
  target_node  = "pve1"
  hostname     = "ubuntu-lxc"
  ostemplate   = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  password     = "terraform"
  unprivileged = true
  onboot = true
  start = true
 ssh_public_keys = <<-EOT
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCZ391jiPNiscavMEeKK08roPB0UhReEhRRicpqI0cy88H4OHHUOPhHdiOZO7tIBHDS2ZBorjZBxNbZg8DLT+dwrW41qbnHrOhcLb7MoAlHosghA6wuMNKshSRzE37jD5le7gqOHreL24TFjV/s6sFanDdvaMoGa3CQd+e6Q8Vq3Y6XZjDylAj35ZD4PBUb+MIUiKReOJ0E0CqT0hoWocdddlCxrJCZweydSkG7oJ44MHvwRIYrHQj4fEJANMKwtEFz4U745e96pZ63vEqK4uZgIbOrcXtSDxMy7W5HNPKpKpdddXwGeyPTecwP2+8iXLWbQ+ITU1dqtGHXHwI7FNLHiYUzIOZ8XCax6SvDqrhg06itgfncwf1eiXo/bPRF9zo5GladjoHQZ0Hsvt//yjSz/lECoQ4b5JjQUkDfPl+qRCNm/WTgvSqfZltb+w96ntS3a+PjGWI59wJcAXC2svs5Bm7gFXlz1YBNdgiWVKqhiO76epaIiGh4MD2FzWfbiHs= root@sam-p-laptop
  EOT

  rootfs {
    storage = "local"
    size    = "32G"
  }

  nameserver = "8.8.8.8"

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "dhcp"
    firewall = true
  }
}
