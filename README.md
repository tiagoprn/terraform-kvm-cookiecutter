# Terraform KVM cookiecutter

This cookiecutter enables creation of kvm virtual machines on linux using
terraform's [libvirt plugin](https://github.com/dmacvicar/terraform-provider-libvirt/).

After running the cookiecutter, enter the folder with the `vm_name` you
specified and run:

`make create`

Terraform will then provision the vm on kvm through libvirt.

After finished, run `make ssh` to ssh into the instance. You can see the other
available commands typing `make`. To interact with libvirt through `virsh`
command, check [my cheatsheet
here](https://github.com/tiagoprn/devops/blob/master/cheats/kvm.cheat).

IMPORTANT: on my github, at `devops/shellscripts/kvm`, there is a pure
shellscript implementation to another wrapper to kvm.

### Growing the disk size:

By default, all images you download probably do not have much space left on
disk so that you can install everything you need. So you will probably need to
resize their qcow2 disk.

To do that, we must first resize the qcow2 disk through qemu and then use

on a new VM running on Virt-Manager to resize the disk. Below are the steps to
do all that:

- Open virt-manager. Search the vm you want to resize there, and stop it if it is
  running.

- Open a terminal to resize the qcow2 disk of the image you want to resize:

```
$ sudo su
$ cd /storage/kvm/storage_pools/[vm-name]
$ qemu-img resize [vm-name].qcow2 +SIZE
$ # (e.g. 10G for 10 gibibytes).
```

- Download [gparted live ISO image](https://downloads.sourceforge.net/gparted/gparted-live-1.1.0-3-amd64.iso)

- Open Virt-Manager and stop the VM if it is running. Then, go to the menu at
  "Edit => Virtual Machine Details". There, click "Show details of virtual
hardware". Click the "Add Hardware" button at the lower left corner. Select
"Storage", on "Device Type" choose "CDROM Device" and add the gparted ISO file.
Click "Finish". Then, go to "Initialization Options", enable the "IDE CDROM"
and move it to the top. Then, click "Apply". Then, click the "Play" icon to
boot the VM, click the monitor icon (show graphical console), boot from gparted
there and use it to resize the partition to its full size. After
finished, poweroff from the gparted ISO, go to "Initialization Options" again,
move the "IDE CDROM" below the virtual disk and disable it. You're done. Now
you must powerup your VM on the CLI through virsh or on Virt Manager. :)

### ONLINE IMAGES YOU CAN USE TO EXPERIMENT WITH THIS COOKIECUTTER:

[Ubuntu 20.04](https://cloud-images.ubuntu.com/releases/focal/release/ubuntu-20.04-server-cloudimg-amd64-disk-kvm.img)
[Centos 8.2](http://cloud.centos.org/centos/8/x86_64/images/CentOS-8-GenericCloud-8.2.2004-20200611.2.x86_64.qcow2)
[Arch Linux (from openstack)](https://linuximages.de/openstack/arch/arch-openstack-LATEST-image-bootstrap.qcow2)

IMPORTANT: the image you use must have cloud-init installed so that it can be
provisioned on first boot. If you are not sure, you can download it locally,
bind mount and chroot into it. Then, you can check to through the package
manager if it is installed. If not, you can install it.

### EXAMPLE OF A DIRECTORY STRUCTURE TO KEEP KVM-RELATED FILES:

- Terraform provisioning: /storage/temp/kvm
- Images *: /storage/kvm/local_images
- Virtual Machines: /storage/kvm/storage_pools
- Virtual Machine Backup: /storage/kvm/backups

[*] you can use remote ones, but if you prefer not to download each time you can store them locally
