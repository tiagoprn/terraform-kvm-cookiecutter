This cookiecutter enables creation of kvm virtual machines on linux using
terraform's [libvirt plugin](https://github.com/dmacvicar/terraform-provider-libvirt/).

After running the cookiecutter, enter the folder with the `vm_name` you
specified and run:

`make create`

Terraform will then provision the vm on kvm through libvirt.

After finished, run `make ssh` to ssh into the instance. You can see the other
available commands typing `make`.

### ONLINE IMAGES YOU CAN USE TO EXPERIMENT WITH THIS COOKIECUTTER:

TODO
