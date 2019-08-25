# this is the scrip that will install, configure and deploy the ansible-awx on the localhost machine 

#changing the user priviledges
sudo su - 
sed -i 's|SELINUX=enforcing|SELINUX=disabled|g' /etc/selinux/config
echo "The host it will reboot in 2 seconds in order to configure the SELINUX!"
echo "Please wait.."
yum -y install epel-release
yum -y install git gcc gcc-c++ lvm2 bzip2 gettext nodejs yum-utils device-mapper-persistent-data ansible python-pip
yum -y remove docker docker-common docker-selinux docker-engine
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum -y install docker-ce
systemctl start docker && systemctl enable docker
pip install docker-compose
sleep 2s
reboot now

git clone --depth 50 https://github.com/ansible/awx.git
dir=$(pwd)
cd dir/awx/installer/
echo ""
echo "checking the inventory configuration"
grep -v '^ *#' inventory | sed '/^$/d'
sed -i 's|admin_password=password|admin_password=yournewpass|g' inventory
echo "generating the security key"
sec_key=$(openssl rand -base64 30)
sed -i 's|secret_key=awxsecret|secret_key='$sec_key'|g' inventory
echo "checking the inventory containing the new configuration"
grep -v '^ *#' inventory | sed '/^$/d'

echo "installing the awx-ansible on the localhost"
echo "Please be patient.."
ansible-playbook -i inventory install.yml

echo "installation has finished. Please visit the http://localhost/ or http://ansible-playbook -i inventory install.yml"
