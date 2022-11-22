touch /boot/ssh

sudo raspi-config nonint do_change_locale en_US.UTF-8
apt-get update
apt-get upgrade -y
apt-get install -y apt-transport-https ca-certificates curl

curl -fsSL https://get.docker.com -o get-docker.sh
LC_ALL="en_US.UTF-8" sh get-docker.sh
usermod -aG docker pi
