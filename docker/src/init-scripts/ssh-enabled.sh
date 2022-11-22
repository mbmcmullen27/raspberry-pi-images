touch /boot/ssh

sudo raspi-config nonint do_change_locale en_US.UTF-8

apt-get update
apt-get upgrade -y
apt-get install -y apt-transport-https ca-certificates curl
