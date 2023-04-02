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

Init folder
```
TODO
```

Build specific template
```
packer build -var-file=common.pkrvars.hcl ubuntu/22.04
```
