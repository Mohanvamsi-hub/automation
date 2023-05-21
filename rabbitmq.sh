script = $(realpath "$0")
script_path = $(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[31m >>>>>>>> Configuring repo file <<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

echo -e "\e[31m >>>>>>>> Install erlang <<<<<<<<<\e[0m"
yum install erlang -y

echo -e "\e[31m >>>>>>>> Configuring repo file for rabbitmq <<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

echo -e "\e[31m >>>>>>>> Installing rabbitmq <<<<<<<<<\e[0m"
yum install rabbitmq-server -y 

echo -e "\e[31m >>>>>>>> Starting the service <<<<<<<<<\e[0m"
systemctl enable rabbitmq-server 
systemctl restart rabbitmq-server 

echo -e "\e[31m >>>>>>>> Adding system user <<<<<<<<<\e[0m"
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
