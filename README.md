# raspberry-spi
raspberry pi spi device configuration

imager requires packages
- libatlas-base-dev
- libopenjp2-7
- python3-pil
- python3-numpy
- python3-pip
- python-rpi.gpio (button)
- python3-rpi.gpio (button)
- parted (for packer)
- packer

imager requires pip3 libraries
- adafruit-circuitpython-display-text==2.21.1
    - the latest version, 2.21.2, causes an 'undefined' error
- adafruit-circuitpython-st7789
- adafruit-blinka-displayio

## Running locally with Packer
- initialize packer build machine with following these [instrunction](https://linuxhit.com/build-a-raspberry-pi-image-packer-packer-builder-arm/)

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
