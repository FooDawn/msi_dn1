echo "Updating and upgrading"
apt-get update > /dev/null
apt-get upgrade -y > /dev/null
export DEBIAN_FRONTEND=noninteractive
echo "Installing debconf-utils"
apt-get install debconf-utils -y > /dev/nul

echo "Installing i3 Window Manager"
apt-get install xorg -y > /dev/nul
apt-get install xinit -y > /dev/nul
apt-get install i3 -y > /dev/nul
echo "exec i3" >> ~/.xinitrc

echo "Installing docker so that gns3 will be able to run currectly"
apt-get install -y apt-transport-https ca-certificates curl software-properties-common > /dev/null
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" > /dev/nul
apt-cache policy docker-ce > /dev/nul
apt-get install docker-ce -y > /dev/nul

# to check if it's running type: sudo systemctl status docker 

echo "Installing GNS3 with build-in wireshark"
add-apt-repository ppa:gns3/ppa -y > /dev/nul
echo "wireshark-common wireshark-common/install-setuid boolean true" | debconf-set-selections
apt-get install gns3-gui gns3-server -y > /dev/nul

# ADD NON-SUDO USER TO GNS3, UBRINGE
usermod -aG ubridge,libvirt,kvm vagrant

echo "Installing midori browser"
apt-get install midori -y > /dev/nul

echo "FINISHED"       