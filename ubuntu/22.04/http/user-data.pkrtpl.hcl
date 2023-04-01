#cloud-config
autoinstall:
  version: 1
  locale: ${vm_guest_os_timezone}
  keyboard:
    layout: ${vm_guest_os_keyboard}
  ssh:
    install-server: true
    allow-pw: true
  packages:
    - openssh-server
    - qemu-guest-agent
    - cloud-init
  storage:
    #layout:
    #  name: direct
    swap:
      size: 0
    config:
      # Partition table
      - id: vda
        type: disk
        ptable: gpt
        path: /dev/vda
        wipe: superblock
        grub_device: true
      # Boot part
      ## Create
      - id: vda1
        type: partition
        size: 1024M
        device: vda
        flag: boot
        wipe: superblock
        number: 1
      ## Format
      - id: vda1-boot
        type: format
        fstype: ${vm_guest_os_fstype}
        label: BOOT
        volume: vda1
      ## Mount
      - id: vda1-mount
        type: mount
        path: /boot
        device: vda1-boot
      # LVM part
      ## Create partition
      - id: vda2
        type: partition
        size: -1
        device: vda
        wipe: superblock
        number: 2
      ## Create VG
      - id: sys
        name: sys
        devices:
          - vda2
        type: lvm_volgroup
      - id: sys
        name: sys
        devices:
          - vda2
        type: lvm_volgroup
      # Root partition
      ## Create
      - id: sys-root
        name: root
        volgroup: sys
        size: 2048M
        wipe: superblock
        type: lvm_partition
      ## Format
      - id: format-root
        type: format
        volume: sys-root
        fstype: ${vm_guest_os_fstype}
        label: ROOT
      ## Mount
      - id: mount-root
        type: mount
        device: format-root
        path: /
      # Tmp partition
      ## Create
      - id: sys-tmp
        name: tmp
        volgroup: sys
        size: 1024M
        wipe: superblock
        type: lvm_partition
      ## Format
      - id: format-tmp
        type: format
        volume: sys-tmp
        fstype: ${vm_guest_os_fstype}
        label: TMP
      ## Mount
      - id: mount-tmp
        type: mount
        device: format-tmp
        path: /tmp
      # Var partition
      ## Create
      - id: sys-var
        name: var
        volgroup: sys
        size: 3072M
        wipe: superblock
        type: lvm_partition
      ## Format
      - id: format-var
        type: format
        volume: sys-var
        fstype: ${vm_guest_os_fstype}
        label: VAR
      ## Mount
      - id: mount-var
        type: mount
        device: format-var
        path: /var
      # Log partition
      ## Create
      - id: sys-log
        name: log
        volgroup: sys
        size: 3072M
        wipe: superblock
        type: lvm_partition
      ## Format
      - id: format-log
        type: format
        volume: sys-log
        fstype: ${vm_guest_os_fstype}
        label: LOG
      ## Mount
      - id: mount-log
        type: mount
        device: format-log
        path: /log
      # Usr partition
      ## Create
      - id: sys-usr
        name: usr
        volgroup: sys
        size: 6144M
        wipe: superblock
        type: lvm_partition
      ## Format
      - id: format-usr
        type: format
        volume: sys-usr
        fstype: ${vm_guest_os_fstype}
        label: USR
      ## Mount
      - id: mount-usr
        type: mount
        device: format-usr
        path: /usr
  user-data:
    package_upgrade: true
    timezone: ${vm_guest_os_timezone}
    users:
      - name: ${build_username}
        passwd: ${build_password_encrypted}
        groups: [adm, cdrom, dip, plugdev, lxd, sudo]
        lock-passwd: false
        sudo: ALL=(ALL) NOPASSWD:ALL
        shell: /bin/bash
        ssh_authorized_keys:
          - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDKvqsyyx7uFjUHyuUvLDGo85Q5yeIhbzr9BXJ8UKgUvUwBLDsv39AswAC79+4jvMiBNzHD3N1knTouYFMn9qGOrqUqvuZsbbIoyYd0SOA2yWv+8tUcNR/LonO6RROsvH1h9h/Njc3878hrEub5wE2SqMu2FCe9cT7IzuacaSM8fvKVVluRFXUH2VFf/8uNZ8VYSi3uwYnibpZ2LdERv9DMz22m28JAeuVz/0WV9B0YZ4Iy1idiodyMGtwKfKxysop7uff73M08LsBn07bpHZ2UITc/OvFw+0m8xJSIBFqvRClffSpNXYBpXEkTWSGqcrRZDY3GRALr4AyzkCwmuR1z ansible
