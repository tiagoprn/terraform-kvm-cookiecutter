- Test the graphical environment with a spice client and a ubuntu20 desktop
  image. If there is not an image for it, install ubuntu20 server and then
install the package ubuntu-desktop ;)
    - do that with the ubuntu20-kvm image, so that I can install the package ubuntu-desktop on it so to test the sppice client to connect graphically to the machine. After finished, move the instructions below to README.md:

### Resize a qcow2 image:
```
sudo su
cd /storage/kvm/storage_pools/[vm-name]
qemu-img resize [vm-name].qcow2 +SIZE
```
(e.g. 10G for 10 gibibytes).

Boot into an external live OS and resize the partition. The easiest way to do
this is to use a GParted live image and virt-manager to connect to the VM.

---

- Test with other volume sources (images):
    IMPORTANT: Put on the README.md file the web location to the images that will be tested below
    * centos7 (check /storage/src/devops/shellscripts/kvm/download_centos7_cloud_image.sh)
    * arch linux (check /storage/src/devops/shellscripts/kvm/download_archlinux_cloud_image.sh)
    * a local image, downloaded to a local folder.


