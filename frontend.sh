script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh



printhead "Installing nginx"
yum install nginx -y &>>$log_file
func_stat_check $?

printhead "copying config file"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$log_file
func_stat_check $?

printhead "removing old app content"
rm -rf /usr/share/nginx/html/* &>>$log_file
func_stat_check $?

printhead "Download code content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip  &>>$log_file
cd /usr/share/nginx/html  &>>$log_file
func_stat_check $?

printhead "Extracting app content"
unzip /tmp/frontend.zip &>>$log_file
func_stat_check $?

printhead "starting nginx service"
systemctl enable nginx 
systemctl restart nginx
func_stat_check $?