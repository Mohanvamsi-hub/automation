script = $(realpath "$0")
script_path = $(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[31m >>>> Installing redis repo file <<<<<< \e[0m"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

echo -e "\e[31m>>>>>>>> Enabling redis version <<<<<<<<\e[0m"
dnf module enable redis:remi-6.2 -y

echo -e "\e[31m>>>>>>>> Installing redis <<<<<<<<\e[0m"
yum install redis -y 

echo -e "\e[31m>>>>>>>> Changing port listen address <<<<<<<<\e[0m"
#change port address
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis.conf /etc/redis/redis.conf

echo -e "\e[31m>>>>>>>> restarting the address <<<<<<<<\e[0m"
systemctl enable redis 
systemctl restart redis 