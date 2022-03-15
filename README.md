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


imager requires pip3 libraries
- adafruit-circuitpython-display-text==2.21.1
    - the latest version, 2.21.2, causes an 'undefined' error
- adafruit-circuitpython-st7789
- adafruit-blinka-displayio

initialize packer build machine with following these [instrunction](https://linuxhit.com/build-a-raspberry-pi-image-packer-packer-builder-arm/)

```sh
# fetch latest build
./fetch-image.sh

# running packer
sudo -E TMPDIR=/var/tmp packer build raspios.json

```
