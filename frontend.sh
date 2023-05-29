script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh



printhead "Installing Maven"
yum install nginx -y &>>$log_file
func_stat_check $?

printhead "Installing Maven"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$log_file
func_stat_check $?

printhead "Installing Maven"
rm -rf /usr/share/nginx/html/* &>>$log_file
func_stat_check $?

printhead "Installing Maven"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip  &>>$log_file
cd /usr/share/nginx/html  &>>$log_file
func_stat_check $?

printhead "Installing Maven"
unzip /tmp/frontend.zip &>>$log_file
func_stat_check $?

printhead "Installing Maven"
systemctl enable nginx 
systemctl restart nginx
func_stat_check $?