# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# RHEL 9.1

### Installs from the first attached CD-ROM/DVD on the system.
cdrom

### Performs the kickstart installation in text mode.
### By default, kickstart installations are performed in graphical mode.
text

### Accepts the End User License Agreement.
eula --agreed

### Sets the language to use during installation and the default language to use on the installed system.
lang ${vm_language}

### Sets the default keyboard type for the system.
keyboard ${vm_keyboard}

### Configure network information for target system and activate network devices in the installer environment (optional)
### --onboot	  enable device at a boot time
### --device	  device to be activated and / or configured with the network command
### --bootproto	  method to obtain networking configuration for device (default dhcp)
### --noipv6	  disable IPv6 on this device
###
### network  --bootproto=static --ip=172.16.11.200 --netmask=255.255.255.0 --gateway=172.16.11.200 --nameserver=172.16.11.4 --hostname centos-linux-8
network --bootproto=dhcp

### Lock the root account.
rootpw --lock

### The selected profile will restrict root login.
### Add a user that can login and escalate privileges.
user --name=${vm_username} --iscrypted --password=${vm_password_encrypted} --groups=wheel

### Configure firewall settings for the system.
### --enabled	reject incoming connections that are not in response to outbound requests
### --ssh		allow sshd service through the firewall
firewall --enabled --ssh

### Sets up the authentication options for the system.
### The SSDD profile sets sha512 to hash passwords. Passwords are shadowed by default
### See the manual page for authselect-profile for a complete list of possible options.
authselect select sssd

### Sets the state of SELinux on the installed system.
### Defaults to enforcing.
selinux --enforcing

### Sets the system time zone.
timezone ${vm_timezone}

### Sets how the boot loader should be installed.
bootloader --location=mbr

### Initialize any invalid partition tables found on disks.
zerombr

### Removes partitions from the system, prior to creation of new partitions.
### By default, no partitions are removed.
### --linux	erases all Linux partitions.
### --initlabel Initializes a disk (or disks) by creating a default disk label for all disks in their respective architecture.
clearpart --all --initlabel

### Modify partition sizes for the virtual machine hardware.
### Create primary system partitions.

part /boot/efi --fstype=efi --size=200 --label=EFI
part /boot --fstype ${vm_fs_type} --size=${vm_part_boot_size} --label=BOOTFS
part swap --size ${vm_swap_size} --fstype swap
part pv.01 --size=100 --grow

### Create a logical volume management (LVM) group.
volgroup sys --pesize=4096 pv.01

### Modify logical volume sizes for the virtual machine hardware.
### Create logical volumes.
logvol / --fstype ${vm_fs_type} --name=root --vgname=sys --size=${vm_part_root_size} --label=ROOTFS
logvol /tmp --fstype ${vm_fs_type} --name=tmp --vgname=sys --size=${vm_part_tmp_size} --label=TMPFS --fsoptions="nodev,noexec,nosuid"
logvol /var --fstype ${vm_fs_type} --name=var --vgname=sys --size=${vm_part_var_size} --label=VARFS --fsoptions="nodev"
logvol /var/log --fstype ${vm_fs_type} --name=log --vgname=sys --size=${vm_part_log_size} --label=LOGFS --fsoptions="nodev,noexec,nosuid"
### Modifies the default set of services that will run under the default runlevel.
services --enabled=NetworkManager,sshd
### Do not configure X on the installed system.
skipx
### Packages selection.
%packages --ignoremissing --excludedocs
@core
-iwl*firmware
%end
### Post-installation commands.
%post
dnf makecache
dnf install epel-release -y
dnf makecache
dnf install -y sudo qemu-guest-agent cloud-init cloud-utils gdisk 
echo "${vm_username} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/${vm_username}
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
yum update -y
%end

### Reboot after the installation is complete.
### --eject attempt to eject the media before rebooting.
reboot --eject
