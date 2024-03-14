CoreOS
======

Use pre-generated ignition files
--------------------------------

In order to build a CoreOS template you can simply include your ssh public key in the provided ignition configuration files.

Generate your own ignition files
--------------------------------

> You'll need to install **butane** if you want to easily generate ignition files.
>
> Here's the "Getting Started" link : https://coreos.github.io/butane/getting-started/
>
> If you don't want to use butane, check [this link](https://docs.fedoraproject.org/en-US/fedora-coreos/producing-ign/)

- Copy the provided butane example files

```
cd coreos/38/config
cp installer.bu{.example,}
cp template.bu{.example,}
```

- Edit these files as you wish

- Convert your butane configuration files to ignition format

```
butane --pretty --strict installer.bu > installer.ign.hcl
butane --pretty --strict template.bu > template.ign.hcl
```

> make sure to include any packer variable needed in the butane file (like vm_pubkey for example)

Build template
--------------

- build CoreOS template

```
packer build -var-file=common.pkrvars.hcl coreos/38
```
