# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Debian 12

# Locale and Keyboard
d-i debian-installer/locale string ${vm_locale}
d-i debian-installer/language string ${vm_language}
d-i keyboard-configuration/xkb-keymap select ${vm_keyboard}
d-i debian-installer/country string ${vm_country}
d-i localechooser/supported-locales multiselect en_US.UTF-8



# Clock and Timezone
d-i clock-setup/utc boolean true
d-i clock-setup/ntp boolean true
d-i time/zone string ${vm_timezone}

# Grub and Reboot Message
d-i finish-install/reboot_in_progress note
d-i grub-installer/only_debian boolean true

# Partitioning
d-i partman-auto/method string lvm
d-i partman-lvm/confirm boolean true
d-i partman-lvm/confirm_nooverwrite boolean true
d-i partman-lvm/device_remove_lvm boolean true
d-i partman-auto-lvm/new_vg_name string sys
d-i partman-efi/non_efi_system boolean true

d-i partman-auto/expert_recipe string                                              \
  custom ::                                                                        \
    ${vm_part_efi_size} ${vm_part_efi_size} ${vm_part_efi_size} fat32              \
    $primary{ }                                                                    \
    mountpoint{ /boot/efi }                                                        \
    method{ efi }                                                                  \
    format{ }                                                                      \
    use_filesystem{ }                                                              \
    filesystem{ vfat }                                                             \
    label { EFIFS }                                                                \
    .                                                                              \
    ${vm_part_boot_size} ${vm_part_boot_size} ${vm_part_boot_size} ${vm_fs_type}   \
    $bootable{ }                                                                   \
    $primary{ }                                                                    \
    mountpoint{ /boot }                                                            \
    method{ format }                                                               \
    format{ }                                                                      \
    use_filesystem{ }                                                              \
    filesystem{ ${vm_fs_type} }                                                    \
    label { BOOTFS }                                                               \
    .                                                                              \
    ${vm_part_swap_size} ${vm_part_swap_size} ${vm_part_swap_size} linux-swap      \
    $lvmok{ }                                                                      \
    lv_name{ swap }                                                                \
    in_vg { sys }                                                                  \
    method{ swap }                                                                 \
    format{ }                                                                      \
    label { SWAPFS }                                                               \
    .                                                                              \
    ${vm_part_root_size} ${vm_part_root_size} ${vm_part_root_size} ${vm_fs_type}   \
    $lvmok{ }                                                                      \
    mountpoint{ / }                                                                \
    lv_name{ root }                                                                \
    in_vg { sys }                                                                  \
    method{ format }                                                               \
    format{ }                                                                      \
    use_filesystem{ }                                                              \
    filesystem{ ${vm_fs_type} }                                                    \
    label { ROOTFS }                                                               \
    .                                                                              \
    ${vm_part_tmp_size} ${vm_part_tmp_size} ${vm_part_tmp_size} ${vm_fs_type}      \
    $lvmok{ }                                                                      \
    mountpoint{ /tmp }                                                             \
    lv_name{ tmp }                                                                 \
    in_vg { sys }                                                                  \
    method{ format }                                                               \
    format{ }                                                                      \
    use_filesystem{ }                                                              \
    filesystem{ ${vm_fs_type} }                                                    \
    label { TMPFS }                                                                \
    options/nodev{ nodev }                                                         \
    options/noexec{ noexec }                                                       \
    options/nosuid{ nosuid }                                                       \
    .                                                                              \
    ${vm_part_var_size} ${vm_part_var_size} ${vm_part_var_size} ${vm_fs_type}      \
    $lvmok{ }                                                                      \
    mountpoint{ /var }                                                             \
    lv_name{ var }                                                                 \
    in_vg { sys }                                                                  \
    method{ format }                                                               \
    format{ }                                                                      \
    use_filesystem{ }                                                              \
    filesystem{ ${vm_fs_type} }                                                    \
    label { VARFS }                                                                \
    options/nodev{ nodev }                                                         \
    .                                                                              \
    ${vm_part_log_size} ${vm_part_log_size} ${vm_part_log_size} ${vm_fs_type}      \
    $lvmok{ }                                                                      \
    mountpoint{ /var/log }                                                         \
    lv_name{ log }                                                                 \
    in_vg { sys }                                                                  \
    method{ format }                                                               \
    format{ }                                                                      \
    use_filesystem{ }                                                              \
    filesystem{ ${vm_fs_type} }                                                    \
    label { LOGFS }                                                                \
    options/nodev{ nodev }                                                         \
    options/noexec{ noexec }                                                       \
    options/nosuid{ nosuid }                                                       \
    .                                                                              \
    ${vm_part_home_size} ${vm_part_home_size} ${vm_part_home_size} ${vm_fs_type}   \
    $lvmok{ }                                                                      \
    mountpoint{ /home }                                                            \
    lv_name{ home }                                                                \
    in_vg { sys }                                                                  \
    method{ format }                                                               \
    format{ }                                                                      \
    use_filesystem{ }                                                              \
    filesystem{ ${vm_fs_type} }                                                    \
    label { HOMEFS }                                                               \
    .                                                                              \
    ${vm_part_usr_size} ${vm_part_usr_size} ${vm_part_usr_size} ${vm_fs_type}      \
    $lvmok{ }                                                                      \
    mountpoint{ /usr }                                                             \
    lv_name{ usr }                                                                 \
    in_vg { sys }                                                                  \
    method{ format }                                                               \
    format{ }                                                                      \
    use_filesystem{ }                                                              \
    filesystem{ ${vm_fs_type} }                                                    \
    label { USRFS }                                                                \
    .

d-i partman-partitioning/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true

# Network configuration
d-i netcfg/choose_interface select auto
d-i netcfg/get_hostname string unassigned-hostname
d-i netcfg/get_domain string unassigned-domain

### Mirror settings
# Mirror protocol:
# If you select ftp, the mirror/country string does not need to be set.
# Default value for the mirror protocol: http.
#d-i mirror/protocol string ftp
d-i mirror/country string manual
d-i mirror/http/hostname string deb.debian.org
d-i mirror/http/directory string /debian
d-i mirror/http/proxy string

# User Configuration
d-i passwd/root-login boolean false
d-i passwd/user-fullname string ${vm_username}
d-i passwd/username string ${vm_username}
d-i passwd/user-password-crypted password ${vm_password_encrypted}

# Package Configuration
d-i pkgsel/run_tasksel boolean false
d-i pkgsel/include string openssh-server qemu-guest-agent gdisk cloud-init

# Add User to Sudoers
d-i preseed/late_command string \
    echo '${vm_username} ALL=(ALL) NOPASSWD: ALL' > /target/etc/sudoers.d/${vm_username} ; \
    in-target chmod 440 /etc/sudoers.d/${vm_username} ;
