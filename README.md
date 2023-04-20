Packer for Proxmox
------------------

Description
===========

This repo is a workspace for template creation in proxmox with packer and proxmox-iso plugin.

Prerequisites
=============

- packer 1.8.6+
- proxmox environment

Usage
=====
Copy example common vars file and fill it with your specific vars.
```
cp common.pkrvars.hcl{.example,}
```

Copy example template specific vars file and fill it with your vars.
```
cp ubuntu/22.04/ubuntu.auto.pkrvars.hcl{.example,}
```

Build specific template
```
packer build -var-file=common.pkrvars.hcl ubuntu/22.04
```

Required vars
=============

These vars are mandatory. Here is some examples.

```
proxmox_url = "https://pve.domain.lan:8006/api2/json"
proxmox_node = "node_name"
proxmox_username = "user@pam"
proxmox_password = "**********"
proxmox_datastore = "" # Where to find iso
proxmox_storage_pool = "" # Where to create VM's disks
vm_username= ""
vm_password = ""
vm_password_encrypted = ""
vm_pubkey = ""
```

> For **vm_password_encrypted** var, you can encrypt password with **mkpasswd -m sha256crypt** on ubuntu.
