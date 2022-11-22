# raspberry-pi-images
raspberry pi image generation

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

```sh
# running in docker
docker run \
    --privileged=true \
    -v /dev:/dev \
    -v $(pwd)/src:/home/builder/src \
    -e script=<image-init-script>
    -it builder 
```
