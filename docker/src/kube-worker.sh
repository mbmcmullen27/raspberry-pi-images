touch /boot/ssh

sudo raspi-config nonint do_change_locale en_US.UTF-8

sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

apt-get update
apt-get upgrade -y
apt-get install -y apt-transport-https ca-certificates curl kubelet=1.22.8-00 kubeadm=1.22.8-00 kubectl=1.22.8-00
sudo apt-mark hold kubelet kubeadm kubectl

curl -fsSL https://get.docker.com -o get-docker.sh
LC_ALL="en_US.UTF-8" sh get-docker.sh
usermod -aG docker pi

systemctl disable dphys-swapfile.service
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

sudo sysctl --system

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system

sudo sed -i '$s/$/ cgroup_enable=cpuset cgroup_enable=memory AND cgroup_memory=1/' /boot/cmdline.txt
sudo update-alternatives --set iptables /usr/sbin/iptables-legacy