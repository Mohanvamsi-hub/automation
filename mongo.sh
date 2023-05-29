script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh



printhead "copying mongo repo file"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
func_stat_check $?

printhead "Installing mongodb"
yum install mongodb-org -y &>>$log_file
func_stat_check $?

printhead "changing address of port"
sed -i -e 's|127.0.0.1|0.0.0.0|g' /etc/mongod.conf &>>$log_file
func_stat_check $?

printhead "starting mongo service"
systemctl enable mongod 
systemctl restart mongod
func_stat_check $?