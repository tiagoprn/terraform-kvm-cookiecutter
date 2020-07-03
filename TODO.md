- Test the graphical environment with a spice client and a ubuntu20 desktop
  image. If there is not an image for it, install ubuntu20 server and then
install the package ubuntu-desktop ;)
    - do that with the ubuntu20-kvm image, so that I can install the package ubuntu-desktop on it so to test the sppice client to connect graphically to the machine. After finished, move the instructions below to README.md:

### Growing the disk size:

To do that, we must first resize the qcow2 disk through qemu and then use
[GParted live
image](https://downloads.sourceforge.net/gparted/gparted-live-1.1.0-3-amd64.iso)
on a new VM running on Virt-Manager to resize the disk. Below are the steps to
do all that:

- Open virt-manager. Search the vm you want to resize there, and stop it if it is
  running.
- Open a terminal to resize the qcow2 disk of the image you want to resize:
```
sudo su
cd /storage/kvm/storage_pools/[vm-name]
qemu-img resize [vm-name].qcow2 +SIZE
```
(e.g. 10G for 10 gibibytes).
- Download the gparted iso
- Open Virt-Manager and stop the VM if it is running. Then, go to the menu at
  "Edit => Virtual Machine Details". There, click "Show details of virtual
hardware". Click the "Add Hardware" button at the lower left corner. Select
"Storage", on "Device Type" choose "CDROM Device" and add the gparted ISO file.
Click "Finish". Then, go to "Initialization Options", enable the "IDE CDROM"
and move it to the top. Then, click "Apply". Then, click the "Play" icon to
boot the VM and use gparted to resize the partition to its full size. After
finished, poweroff from the gparted ISO, go to "Initialization Options" again,
move the "IDE CDROM" below the virtual disk and disable it. You're done. Now
you must powerup your VM on the CLI or on Virt Manager. :)


---

- Test with other volume sources (images):
    IMPORTANT: Put on the README.md file the web location to the images that will be tested below
    * centos7 (check /storage/src/devops/shellscripts/kvm/download_centos7_cloud_image.sh)
    * arch linux (check /storage/src/devops/shellscripts/kvm/download_archlinux_cloud_image.sh)
    * a local image, downloaded to a local folder.


