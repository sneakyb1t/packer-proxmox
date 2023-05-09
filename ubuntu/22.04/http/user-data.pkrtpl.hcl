#cloud-config
autoinstall:
  version: 1
  keyboard:
    layout: ${vm_keyboard}
    toggle: null
    variant: ''
  locale: ${vm_timezone}
  storage:
    config:
    # Partition table
    - { ptable: gpt, path: /dev/vda, wipe: superblock, preserve: false, name: '', grub_device: false, type: disk, id: disk-vda }
    # EFI boot partition
    - { device: disk-vda, size: ${vm_part_efi_size}, wipe: superblock, flag: boot, number: 1, preserve: false, grub_device: true, type: partition, id: partition-0 }
    - { fstype: fat32, volume: partition-0, preserve: false, type: format, id: format-0 }
    # Linux boot partition
    - { device: disk-vda, size: ${vm_part_boot_size}, wipe: superblock, flag: '', number: 2, preserve: false, grub_device: false, type: partition, id: partition-1 }
    - { fstype: ${vm_fs_type}, volume: partition-1, preserve: false, type: format, id: format-1 }
    # Partition for LVM, VG
    - { device: disk-vda, size: -1, wipe: superblock, flag: '', number: 3, preserve: false, grub_device: false, type: partition, id: partition-2 }
    - { name: sys, devices: [ partition-2 ], preserve: false, type: lvm_volgroup, id: lvm_volgroup-0 }
    # LV for root
    - { name: root, volgroup: lvm_volgroup-0, size: ${vm_part_root_size}, wipe: superblock, preserve: false, type: lvm_partition, id: lvm_partition-0 }
    - { fstype: ${vm_fs_type}, volume: lvm_partition-0, preserve: false, type: format, id: format-2 }
    # LV for tmp
    - { name: tmp, volgroup: lvm_volgroup-0, size: ${vm_part_tmp_size}, wipe: superblock, preserve: false, type: lvm_partition, id: lvm_partition-1 }
    - { fstype: ${vm_fs_type}, volume: lvm_partition-1, preserve: false, type: format, id: format-3 }
    # LV for var
    - { name: var, volgroup: lvm_volgroup-0, size: ${vm_part_var_size}, wipe: superblock, preserve: false, type: lvm_partition, id: lvm_partition-2 }
    - { fstype: ${vm_fs_type}, volume: lvm_partition-2, preserve: false, type: format, id: format-4 }
    # LV for log
    - { name: log, volgroup: lvm_volgroup-0, size: ${vm_part_log_size}, wipe: superblock, preserve: false, type: lvm_partition, id: lvm_partition-3 }
    - { fstype: ${vm_fs_type}, volume: lvm_partition-3, preserve: false, type: format, id: format-5 }
    # LV for usr
    - { name: usr, volgroup: lvm_volgroup-0, size: ${vm_part_usr_size}, wipe: superblock, preserve: false, type: lvm_partition, id: lvm_partition-4 }
    - { fstype: ${vm_fs_type}, volume: lvm_partition-4, preserve: false, type: format, id: format-6 }
    # Mount points
    - { path: /usr, device: format-6, type: mount, id: mount-6 }
    - { path: /var/log, device: format-5, type: mount, id: mount-5 }
    - { path: /var, device: format-4, type: mount, id: mount-4 }
    - { path: /tmp, device: format-3, type: mount, id: mount-3 }
    - { path: /, device: format-2, type: mount, id: mount-2 }
    - { path: /boot, device: format-1, type: mount, id: mount-1 }
    - { path: /boot/efi, device: format-0, type: mount, id: mount-0 }
    # Swapfile on root volume
    swap:
      swap: ${vm_swap_size}
  packages:
    - openssh-server
    - qemu-guest-agent
    - cloud-init
    - gdisk
    - cloud-utils

  ssh:
    install-server: true
    allow-pw: true
  user-data:
    package_upgrade: true
    timezone: ${vm_timezone}
    users:
      - name: ${vm_username}
        passwd: ${vm_password_encrypted}
        groups: [adm, cdrom, dip, plugdev, lxd, sudo]
        lock-passwd: false
        sudo: ALL=(ALL) NOPASSWD:ALL
        shell: /bin/bash
        ssh_authorized_keys:
          - ${vm_pubkey}
  late-commands:
  - curtin in-target --target=/target -- sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=""/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/' /etc/default/grub
  - curtin in-target --target=/target -- apt-get update -y && apt-get upgrade -y
