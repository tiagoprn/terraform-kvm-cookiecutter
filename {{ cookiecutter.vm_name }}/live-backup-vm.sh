#!/bin/bash

# e.g.
SYNTAX="./live-backup-vm.sh -d [DESCRIPTION]"
HELP="./live-backup-vm.sh -d after-adding-package"

while getopts d: option
do
  case "${option}"
  in
  d) DESCRIPTION=${OPTARG};;
  esac
done

echo 'Parsing script parameters...'
if [[ -z $DESCRIPTION ]]; then
    printf "Missing -d parameter. Syntax: \n\n$SYNTAX\n\nE.g.: \n\n$HELP\n";
    exit 1
fi

VM_NAME={{ cookiecutter.vm_name }}
STORAGE_POOL_ROOT={{ cookiecutter.storage_pool }}
TIMESTAMP="$(date "+%Y%m%d.%H%M.%S")"
BACKUPS_PATH={{ cookiecutter.backups_path }}
SNAPSHOTS_DIR=$BACKUPS_PATH/snapshots/$VM_NAME/$TIMESTAMP.$DESCRIPTION
BACKUPS_ROOT=$BACKUPS_PATH/$VM_NAME
BACKUPS_DIR=$BACKUPS_ROOT/$TIMESTAMP.$DESCRIPTION
VM_FILE=$(virsh -c qemu:///system domblklist $VM_NAME | grep vda | awk {'print $2'})
VM_PATH=$STORAGE_POOL_ROOT/$VM_NAME/$VM_FILE
BACKUP_NAME="$VM_NAME.$TIMESTAMP.$DESCRIPTION"
echo "Creating snapshots dir $SNAPSHOTS_DIR...";
mkdir -p $SNAPSHOTS_DIR
echo "Creating backups dir $BACKUPS_DIR...";
mkdir -p $BACKUPS_DIR
echo "Dumping machine domain xml definition (VM_NAME=$VM_NAME, BACKUPS_DIR=$BACKUPS_DIR)..."
virsh -c qemu:///system dumpxml $VM_NAME > $BACKUPS_DIR/config.xml
echo "Creating the snapshot, so that the disk operations will be directed to it for you to copy the original disk file to a safe place (VM_NAME=$VM_NAME, BACKUP_NAME=$BACKUP_NAME, SNAPSHOTS_DIR=$SNAPSHOTS_DIR, VM_NAME=$VM_NAME)..."
virsh snapshot-create-as --no-metadata --domain $VM_NAME $BACKUP_NAME --diskspec vda,file=$SNAPSHOTS_DIR/$VM_NAME --disk-only --atomic
echo "Backing up the original disk (VM_PATH=$VM_PATH, BACKUPS_DIR=$BACKUPS_DIR)..."
cp -farv $VM_PATH $BACKUPS_DIR
echo "Creating a compressed copy of the backup (BACKUPS_ROOT=$BACKUPS_ROOT, BACKUP_NAME=$BACKUP_NAME, BACKUPS_DIR=$BACKUPS_DIR )..."
tar cfjv $BACKUPS_ROOT/$BACKUP_NAME.tar.bz2 $BACKUPS_DIR
echo "Redirecting disk operations to the original disk (VM_NAME=$VM_NAME)..."
virsh blockcommit $VM_NAME vda --active --pivot --shallow --verbose

RESTORE_1="To restore, run: "
RESTORE_2="sudo python3 restore_kvm_backup.py -x '$BACKUPS_DIR/config.xml' -b '$BACKUPS_DIR/$VM_FILE' -n '$VM_NAME' -i '$VM_PATH'"

echo $RESTORE_1 >> BACKUPS_DIR/README.md
echo $RESTORE_2 >> BACKUPS_DIR/README.md
