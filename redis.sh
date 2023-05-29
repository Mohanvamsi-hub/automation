script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh


printhead "downloading redis repo file"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$log_file
func_stat_check $?

printhead "Enabling redis version"
dnf module enable redis:remi-6.2 -y &>>$log_file
func_stat_check $?

printhead "installing redis"
yum install redis -y  &>>$log_file
func_stat_check $?

printhead "Changing port listen address"
#change port address
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis.conf /etc/redis/redis.conf &>>$log_file
func_stat_check $?

printhead "starting redis service"
systemctl enable redis 
systemctl restart redis
func_stat_check $?