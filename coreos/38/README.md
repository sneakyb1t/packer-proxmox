CoreOS
=============

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
