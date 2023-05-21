script = $(realpath "$0")
script_path = $(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[31m >>>>>>> Disabling SQL version 8 <<<<<<\e[0m"
dnf module disable mysql -y 

echo -e "\e[31m >>>>>>> setting up sql repo file <<<<<<\e[0m"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo

echo -e "\e[31m >>>>>>> Installing MYSQL <<<<<<\e[0m"
yum install mysql-community-server -y

echo -e "\e[31m >>>>>>> Starting MYSQL service <<<<<<\e[0m"
systemctl enable mysqld
systemctl restart mysqld 

echo -e "\e[31m >>>>>>> Using password to login <<<<<<\e[0m"
mysql_secure_installation --set-root-pass RoboShop@1
