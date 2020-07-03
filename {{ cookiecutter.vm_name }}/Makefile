.PHONY: help
SHELL:=/bin/bash
PROJECT_ROOT=$(shell pwd)

help:  ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

generate-cloud-init-config:  ## Generates the cloud init file
	./generate_cloud_init_file.sh {{ cookiecutter.vm_name }}  # -$(shell date +%Y%m%d%H%M%S)

create: generate-cloud-init-config  ## Create the VM and its associated resources on KVM
	terraform init && terraform plan && terraform apply

destroy:  ## Destroy the VM and its associated resources on KVM
	terraform destroy && rm terraform.tfstate*

status:  ## List the VM and its associated resources on KVM
	terraform refresh && terraform show

ip:  ## Get the VM IP
	@terraform show | grep -E -o '([0-9]{1,3}[\.]){3}[0-9]{1,3}' | grep -v '^127' | grep -v '\.0$$'

ssh:  ## ssh into the VM
	@ssh {{ cookiecutter.vm_sudo_user_name }}@$(shell terraform show | grep -E -o '([0-9]{1,3}[\.]){3}[0-9]{1,3}' | grep -v '^127' | grep -v '\.0$$')
