# raspberry-pi-images
raspberry pi image generation
- This repo produces raspberry pi os images that are ready for common tasks. Namely:
    - kubernetes nodes
        - enables ssh
        - installs:
            - kubeadm
            - kubectl
            - kubelet
            - docker
            - curl
    - docker host
        - enables ssh
        - installs:
            - docker
            - curl
    - ssh enabled 
        - enables ssh
        - installs:
            - curl
            
- Simply download the desired image, decompress, and flash to an sd card
    ```sh
    # List latest available release asset names, select one and export as an env var $NAME
    curl -s https://api.github.com/repos/mbmcmullen27/raspberry-pi-images/releases/latest | jq '.assets[].name'
    export NAME=raspios-ssh-enabled.tar.gz
    
    # Download the archive
    curl -s https://api.github.com/repos/mbmcmullen27/raspberry-pi-images/releases/latest \
        | jq -r --arg NAME = "$NAME" '.assets[] | select( .name == $NAME).browser_download_url' \
        | wget -qi -
        
    # Extract image and flash the card
    tar -xvf $NAME
    sudo dd if=docker/src/custom-raspios-arm.img of=/dev/<SD CARD DEVICE NAME> bs=4M status=progress conv=fsync
    ```

## Running Templates Locally With Packer
- initialize packer build machine with following these [instructions](https://linuxhit.com/build-a-raspberry-pi-image-packer-packer-builder-arm/)
    - needs: 
        - qemu-user-static 
        - qemu-utils
        - [packer-builder-arm](https://github.com/mkaczanowski/packer-builder-arm)
            - installed into `~/.packer.d/plugins`
- use fetch-image.sh script to update the packer template with the latest raspios release and build

    ```sh
    # usage 
    ./fetch-image.sh -h

    cd pi-imager
    ./fetch-image -u
    ./fetch-image -b
    ```

## Running Builder With Docker 
- See packages for latest image tag
- Provide an install script to be run on the base image with packer
```sh
docker run \
    --privileged=true \
    -v /dev:/dev \
    -v $(pwd)/src:/home/builder/src \
    -e script=<image-init-script>
    -it ghcr.io/mbmcmullen27/raspberry-pi-images:<latest image tag>
```
