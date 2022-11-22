# raspberry-pi-images
raspberry pi image generation

## Running locally with Packer
- initialize packer build machine with following these [instructions](https://linuxhit.com/build-a-raspberry-pi-image-packer-packer-builder-arm/)
    - needs: 
        - qemu-user-static 
        - qemu-utils
        - [packer-builder-arm](https://github.com/mkaczanowski/packer-builder-arm)
            - installed into `~/.packer.d/plugins`

## running from docker (this is how this repo produces releases)
- detailed instructions found in the [packer-builder-arm repo](https://github.com/mkaczanowski/packer-builder-arm) 
- use fetch-image.sh script to update the packer template with the latest raspios release

```sh
# usage 
./fetch-image.sh -h

# running packer-arm-builder in docker
docker run --rm --privileged -v /dev:/dev -v ${PWD}:/build mkaczanowski/packer-builder-arm build raspberry-spi/pi-imager/raspios.json

# running packer locally
sudo -E TMPDIR=/var/tmp packer build \
    -var "hostname=${PKR_HOSTNAME-'raspberrypi'}" \
    -var "ssid-name=$PKR_SSID" \
    -var "ssid-pass=$PKR_SSID_PASS" \
    raspios.json
```
