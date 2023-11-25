Packer for Proxmox
===================

This repository provides an easy way to create VM templates in Proxmox using Packer and the Proxmox plugin.
You can install packer and provision either from Proxmox or any other host that has access to Proxmox API

Prerequisites
=============

- Packer 1.8.6+ installed on your system
- A Proxmox environment running version 7.X 8.x
- A user that has sufficient privileges to create the needed ressources

```
packer init require.pkr.hcl
```

Installing Packer
=================

To install Packer on other Linux distributions, please follow the official installation guide: https://learn.hashicorp.com/tutorials/packer/getting-started-install.

Usage
=====

1. Copy the example common variables file and fill it in with your specific variables:

```
cp common.pkrvars.hcl{.example,}

```
2. Set the following required variables in your `common.pkrvars.hcl` file:

```
proxmox_url = "https://pve.domain.lan:8006/api2/json"
proxmox_node = "node_name"
proxmox_username = "user@pam"
proxmox_password = "**********"
proxmox_datastore = "" # Where to find iso file
proxmox_storage_pool = "" # Where the template disks will be created
vm_username= ""
vm_password_encrypted = ""
```

   To create an encrypted `vm_password_encrypted` value, you can use one of the following commands:
   - `mkpasswd -m sha256crypt` on Debian-based distributions
   - `openssl passwd -6` on recent RHEL-based distributions
   - `python3 -c 'import crypt,getpass; print(crypt.crypt(getpass.getpass()))'` using Python

3. Build a template :

```
packer build -var-file=common.pkrvars.hcl ubuntu/22.04
packer build -var-file=common.pkrvars.hcl rocky/9.1
packer build -var-file=common.pkrvars.hcl debian/11
packer build -var-file=common.pkrvars.hcl rhel/8.7
```

Customization
=============

You can customize your template by adding missing values to `variables.hcl` or `distro.hcl`, or you can override any of the values in `variables.hcl` by editing the `common.pkrvars.hcl` file.
Editing variables in this file will override any default values. 
In most common cases, you will just need to uncomment the variables needed in the `common.pkrvars.hcl` file and use your own values.

You can use the `--debug` option in Packer to interactively check what's going on during provision along with `PACKER_LOG=1` variable to get more verbose logging.

To enable debug logging, run:

```
PACKER_LOG=1 packer build -debug -var-file=common.pkrvars.hcl rocky/9.1
```

Ansible provisioning
=============
One of the steps of template preparation is by using ansible roles.
openscap role is provided as an exemple.
Feel free to fill in with your custom roles


Specific OS requirements
=============
CoreOS

In order to build a CoreOS template you can simply include your ssh public key in the provided ignition configuration files.

You can use the pregenerated ignition files in this project or you can generate your own configuration :

- Convert the example butane files provided in this repo and convert it to ignition files

install butane:
https://coreos.github.io/butane/getting-started/


```
cd coreos/38/config
cp installer.bu{.example,}
cp template.bu{.example,}
```
Edit the installer.bu and template.bu

Convert your butane configuration files to ignition format, make sure to include any packer variable needed in the butane file (like vm_pubkey for example):
```
butane --pretty --strict installer.bu > installer.ign.hcl
butane --pretty --strict template.bu > template.ign.hcl
```

Or

- Create ignition files manually https://docs.fedoraproject.org/en-US/fedora-coreos/producing-ign/

Then

build coreos template
```
packer build -var-file=common.pkrvars.hcl coreos/38
```
