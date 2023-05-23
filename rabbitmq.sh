script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_user_password=$1

if [ -z $rabbitmq_user_password ]
then
    echo Input password is missing
    exit 
fi


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
rabbitmqctl add_user roboshop ${rabbitmq_user_password}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
