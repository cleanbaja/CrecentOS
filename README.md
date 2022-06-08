## CrecentOS

CrecentOS is a modern unix operating system designed around the [9x kernel](https://github.com/cleanbaja/9x). As its reference implmentation, CrecentOS recives first-class support from the 9x project. Finally, CrecentOS uses a combination of Unix & GNU Applications, to achive its modern userspace.

### Building

To build CrecentOS, one must have jinx installed. Either click on [this](https://github.com/mintsuki/jinx) link, or for arch linux users, run `yay -S jinx` to complete the installation. Upon installing Jinx (and Docker, its used for the containers), run the following commands.

```
jinx build-all
```

*NOTE: For the above command to work, you must be in the docker group!*

### Running

In `build-support`, there are various scripts to aid in the creation of a bootable image. While there are many, only 2 of them are of importance, `build-support/create_image.sh` and `build-support/run_vm.sh`. The first script creates a image, while the second one runs it. One should use them as follows...

```
# Creates a disk image, crcnt.hdd
./scripts/create_image.sh

# Run the created image like this...
./scripts/run_vm.sh -i crcnt.hdd -f hd
```

