touch /boot/ssh

sudo raspi-config nonint do_change_locale en_US.UTF-8

apt-get update
apt upgrade -y
apt install -y apt-transport-https ca-certificates curl nfs-kernel-server

sudo systemctl enable nfs-kernel-server

uuid=$(blkid /dev/sda1 | grep -oP '(?<= UUID=\")[^\"]*')
echo 'UUID=\"$uuid\"    /srv/nfs    auto    nosuid,nodev,nofail,noatime 0 0' | sudo tee /etc/fstab

sudo mkdir -p /srv/nfs
sudo chmod 777 -R /srv/nfs
echo '/nfs/srv/    {{user `subnet`}}' | tee /etc/exports
