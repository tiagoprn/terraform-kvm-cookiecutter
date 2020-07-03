- Test the graphical environment with a spice client and the ubuntu20 VM:
    * start the vm, ssh into it with `make ssh` and install the package ubuntu-desktop ;)
    * systemctl enable gdm/lightdm
    * stop the VM
    * Open virt-manager and boot the VM from there.

- Test with other volume sources (images):
    IMPORTANT: Put on the README.md file the web location to the images that will be tested below
    * centos7 (check /storage/src/devops/shellscripts/kvm/download_centos7_cloud_image.sh)
    * arch linux (check /storage/src/devops/shellscripts/kvm/download_archlinux_cloud_image.sh)
    * a local image, downloaded to a local folder.

- Migrate my script that creates the live backup
  (/storage/src/devops/shellscripts/kvm/live-backup-vm.sh and restore_kvm_backup.py) to here.
