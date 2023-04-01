#cloud-config
autoinstall:
  version: 1
  apt:
    geoip: true
    preserve_sources_list: false
    primary:
      - arches: [amd64, i386]
        uri: http://archive.ubuntu.com/ubuntu
      - arches: [default]
        uri: http://ports.ubuntu.com/ubuntu-ports
  early-commands:
    - sudo systemctl stop ssh
  locale: ${vm_guest_os_timezone}
  keyboard:
    layout: ${vm_guest_os_keyboard}
  storage:
    config:
      - ptable: gpt
        path: /dev/vda
        wipe: superblock
        type: disk
        id: disk-vda
      - device: disk-vda
        size: 1024M
        wipe: superblock
        flag: boot
        number: 1
        grub_device: true
        type: partition
        id: partition-0
      - fstype: fat32
        volume: partition-0
        label: EFI
        type: format
        id: format-efi
      - device: disk-vda
        size: 1024M
        wipe: superblock
        number: 2
        type: partition
        id: partition-1
      - fstype: ${vm_guest_os_fstype}
        volume: partition-1
        label: BOOT
        type: format
        id: format-boot
      - device: disk-vda
        size: -1
        wipe: superblock
        number: 3
        type: partition
        id: partition-2
      - name: sys
        devices:
          - partition-2
        type: lvm_volgroup
        id: vg
      - name: root
        volgroup: vg
        size: 2048M
        wipe: superblock
        type: lvm_partition
        id: lvm_partition-root
      - fstype: ${vm_guest_os_fstype}
        volume: lvm_partition-root
        type: format
        label: ROOT
        id: format-root
      - name: tmp
        volgroup: vg
        size: 1024M
        wipe: superblock
        type: lvm_partition
        id: lvm_partition-tmp
      - fstype: ${vm_guest_os_fstype}
        volume: lvm_partition-tmp
        type: format
        label: TMP
        id: format-tmp
      - name: var
        volgroup: vg
        size: 3072M
        wipe: superblock
        type: lvm_partition
        id: lvm_partition-var
      - fstype: ${vm_guest_os_fstype}
        volume: lvm_partition-var
        type: format
        label: VAR
        id: format-var
      - name: log
        volgroup: vg
        size: 2048M
        wipe: superblock
        type: lvm_partition
        id: lvm_partition-log
      - fstype: ${vm_guest_os_fstype}
        volume: lvm_partition-log
        type: format
        label: LOG
        id: format-log
      - path: /
        device: format-root
        type: mount
        id: mount-root
      - path: /boot
        device: format-boot
        type: mount
        id: mount-boot
      - path: /boot/efi
        device: format-efi
        type: mount
        id: mount-efi
      - path: /tmp
        device: format-tmp
        type: mount
        id: mount-tmp
      - path: /var
        device: format-var
        type: mount
        id: mount-var
      - path: /var/log
        device: format-log
        type: mount
        id: mount-log
  identity:
    hostname: ${vm_guest_os_hostname}
    username: ${build_username}
    password: ${build_password_encrypted}
  ssh:
    install-server: true
    allow-pw: true
  packages:
    - openssh-server
    - qemu-guest-agent
    - cloud-init
  user-data:
    disable_root: false
    timezone: ${vm_guest_os_timezone}
  late-commands:
    - sed -i -e 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /target/etc/ssh/sshd_config
    - echo '${build_username} ALL=(ALL) NOPASSWD:ALL' > /target/etc/sudoers.d/${build_username}
    - curtin in-target --target=/target -- chmod 440 /etc/sudoers.d/${build_username}
