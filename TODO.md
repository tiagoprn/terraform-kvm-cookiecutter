- Borrow configuration from this `libvirt.tf`: https://titosoft.github.io/kvm/terraform-and-kvm/ (the custom network and disk part I mention below):
    - Add to `cookiecutter.json` a variable to define a custom network:
      https://github.com/dmacvicar/terraform-provider-libvirt/blob/master/website/docs/r/network.markdown
    - Create a VM with the default parameters, and check if I can create a file
      with e.g. 5GB using dd on it. If not, change the disk file size of the
images according to this link (see the `size` argument there):
https://github.com/dmacvicar/terraform-provider-libvirt/blob/master/website/docs/r/volume.html.markdown#argument-reference

- Test with other volume sources (images):
IMPORTANT: Put on the README.md file the web location to the images that will be tested below
    * ubuntu18
    * centos7 (check /storage/src/devops/shellscripts/kvm/download_centos7_cloud_image.sh)
    * arch linux (check /storage/src/devops/shellscripts/kvm/download_archlinux_cloud_image.sh)
    * a local image, downloaded to a local folder

- Test communication between 2 VMs

- Test the graphical environment with a spice client and a ubuntu20 desktop
  image. If there is not an image for it, install ubuntu20 server and then
install the package ubuntu-desktop ;)

