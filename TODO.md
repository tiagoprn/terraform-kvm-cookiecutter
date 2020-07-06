- Relevant local commands/paths:
```
$ sudo watch -n 1 virsh list --all
$ cd /storage/temp/kvm
$ cd /storage/kvm/local_images
$ cd /storage/kvm/storage_pools
$ cd /storage/kvm/backups
```


[ ] Test the graphical environment with virt-manager and the ubuntu20 VM:
* reboot the machine for clean memory
* Create a qcow2 10GB disk to create an image into `/storage/temp/kvm` . Through virt-manager, install
  ubuntu 20 ISO into that image.
* After finished installing, stop the VM and make a copy of it into `/storage/kvm/local_images`.
* Mount the image locally as a loop device and install cloud-init on it. Make a
  new copy after finished.
* Create a new VM using this cookiecutter, pointing to the local file of the
  ubuntu2004 VM. After finished, turn it off.
* Open virt-manager and boot the VM from there to test the graphical environment.

[ ] Test with other volume sources (images):
IMPORTANT: Put on the README.md file the web location to the images that will be tested below
* centos7 (check /storage/src/devops/shellscripts/kvm/download_centos7_cloud_image.sh)
* arch linux (check /storage/src/devops/shellscripts/kvm/download_archlinux_cloud_image.sh)
* a local image, downloaded to a local folder.

