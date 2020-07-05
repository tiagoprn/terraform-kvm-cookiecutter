"""
Given a KVM machine description file, parse its XML
and change the contents of the nodes "name" and "disk/source.file".

Usage:

sudo python restore_kvm_backup.py \
-x '/storage/kvm/backups/ubuntu/20180924.0850.23/config.xml' \
-b '/storage/kvm/backups/ubuntu/20180924.0850.23/centos7-06.qcow2' \
-n 'ubuntu' \
-i '/storage/kvm/storage_pools/ubuntu/ubuntu-qcow2';

"""

import argparse
import os
import subprocess
import sys
from time import sleep

cli_parser = argparse.ArgumentParser()
cli_parser.add_argument(
    "-x",
    "--xml-file",
    required=True,
    help="the backup kvm xml configuration file "
    "containing the machine description.",
)
cli_parser.add_argument(
    "-b",
    "--backup-image-file",
    required=True,
    help="the full path to the qcow2 image file to be restored",
)
cli_parser.add_argument(
    "-n",
    "--vm-name",
    required=True,
    help="image name of the vm to show on make status",
)
cli_parser.add_argument(
    "-i",
    "--destination-image-file",
    required=True,
    help="the full path to where the qcow2 image must be restored",
)
args = vars(cli_parser.parse_args())

XML_FILE = args['xml_file']
VM_NAME = args['vm_name']
BACKUP_IMAGE_FILE = args['backup_image_file']
IMAGE_FILE = args['destination_image_file']

if not os.path.exists(XML_FILE):
    print(
        'The backup vm XML config file was not found, impossible to move on.'
    )
    sys.exit(1)

if not os.path.exists(BACKUP_IMAGE_FILE):
    print('The backup image file was not found, impossible to move on.')
    sys.exit(1)


if __name__ == "__main__":
    print('Shutting down vm if it is active...')
    subprocess.run(['sudo', 'virsh', 'shutdown', VM_NAME])
    print('Removing existing vm...')
    subprocess.run(['sudo', 'virsh', 'undefine', VM_NAME])
    print('Removing disk for the existing vm...')
    if os.path.exists(IMAGE_FILE):
        os.unlink(IMAGE_FILE)
    print('Copying the backup disk as the vm disk...')
    subprocess.run(['sudo', 'cp', '-farv', BACKUP_IMAGE_FILE, IMAGE_FILE])
    print('Restoring vm to the backup image...')
    subprocess.run(
        ['sudo', 'virsh', '-c', 'qemu:///system', 'define', XML_FILE,]
    )
    print('Giving some time before starting the vm...')
    sleep(5)
    print('Starting the restored vm now...')
    subprocess.run(['sudo', 'virsh', '-c', 'qemu:///system', 'start', VM_NAME])
    print('DONE.')
