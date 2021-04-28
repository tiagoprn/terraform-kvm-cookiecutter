.PHONY: help
SHELL:=/bin/bash
PROJECT_ROOT=$(shell pwd)

help:  ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

network-create:  ## Creates the network that the VM will attach to
	sudo virsh net-define kvm-nat-network.xml
	sudo virsh net-start br1
	sudo virsh net-autostart br1

generate-cloud-init-config:  ## Generates the cloud init file
	./generate_cloud_init_file.sh {{ cookiecutter.vm_name }}  # -$(shell date +%Y%m%d%H%M%S)

create: generate-cloud-init-config  ## Create the VM and its associated resources on KVM
	terraform init && terraform plan && terraform apply
	@echo 'Resizing disk...'
	sudo virsh blockresize {{ cookiecutter.vm_name }} {{ cookiecutter.storage_pool }}/{{ cookiecutter.vm_name }}/{{ cookiecutter.vm_name }}-qcow2 {{ cookiecutter.volume_size }}
	@echo 'Resize finished, restarting VM...'
	sudo virsh shutdown {{ cookiecutter.vm_name }}
	sudo virsh start {{ cookiecutter.vm_name }}
	@echo 'FINISHED.'

destroy:  ## Destroy the VM and its associated resources on KVM
	echo "Destroying kvm resources through terraform..."
	terraform destroy && rm terraform.tfstate*
	echo "Deleting VM backups folder..."
	sudo rm -fr {{ cookiecutter.backups_path }}/{{ cookiecutter.vm_name }}
	echo "Deleting VM snapshots folder..."
	sudo rm -fr {{ cookiecutter.backups_path }}/snapshots/{{ cookiecutter.vm_name }}
	echo 'Finished. You will have to delete this directory ($(PROJECT_ROOT)) manually.'

status:  ## List the VM and its associated resources on KVM
	terraform refresh && terraform show

ip:  ## Get the VM IP
	@terraform show | grep -E -o '([0-9]{1,3}[\.]){3}[0-9]{1,3}' | grep -v '^127' | grep -v '\.0$$'

ssh:  ## ssh into the VM
	@ssh {{ cookiecutter.vm_sudo_user_name }}@$(shell terraform show | grep -E -o '([0-9]{1,3}[\.]){3}[0-9]{1,3}' | grep -v '^127' | grep -v '\.0$$')

livebackup:  ## live backup of the VM. E.g.: make livebackup description=after-new-package
	@sudo ./live-backup-vm.sh -d $(description)
