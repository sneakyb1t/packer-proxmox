Role Name
=========

Ansible role to install openscap and apply remediation tasks

Requirements
------------
none

Role Variables
--------------
In defaults/main.yml there are some conditional variables, those are set to load specific variables for each OS distribution/version
In vars there are variables for each distribution/version

Dependencies
------------
none

Example Playbook
----------------
This role is used via ansible-local plugin in packer deployment, could be used with ansible plugin (not tested yet), here an exemple of playbook

- hosts: localhost
  become: yes
  become_user: root
  become_method: sudo
  roles:
    - roles/openscap

License
-------
Yet to define

Author Information
------------------

Yet to define 
