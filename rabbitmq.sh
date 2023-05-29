script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_user_password=$1

if [ -z $rabbitmq_user_password ]
then
    echo Input password is missing
    exit 
fi


printhead "Configuring repo file"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash  &>>$log_file
func_stat_check $?

printhead "Install erlang"
yum install erlang -y  &>>$log_file
func_stat_check $?

printhead "Configuring repo file for rabbitmq"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash  &>>$log_file
func_stat_check $?

printhead "Installing rabbitmq"
yum install rabbitmq-server -y  &>>$log_file
func_stat_check $?

printhead "Starting the service"
systemctl enable rabbitmq-server 
systemctl restart rabbitmq-server
func_stat_check $?

printhead "Adding system user"
rabbitmqctl add_user roboshop ${rabbitmq_user_password}  &>>$log_file
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>>$log_file
func_stat_check $?
