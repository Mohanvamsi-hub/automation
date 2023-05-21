script = $(realpath "$0")
script_path = $(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[31m>>>>>>>> Setup NodeJS repo <<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[31m>>>>>>>> Installing nodejs <<<<<<<<\e[0m"
yum install nodejs -y

echo -e "\e[31m>>>>>>>> Adding user and creating a directory <<<<<<<<\e[0m"
useradd ${app_user}
rm -rf /app
mkdir /app 

echo -e "\e[31m>>>>>>>> Setup code repo <<<<<<<<\e[0m"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip 

echo -e "\e[31m>>>>>>>> Moving into the app directory <<<<<<<<\e[0m"
cd /app 

echo -e "\e[31m>>>>>>>> unzipping code content <<<<<<<<\e[0m"
unzip /tmp/user.zip

echo -e "\e[31m>>>>>>>> Installing nodejs dependancies <<<<<<<<\e[0m"
npm install 

echo -e "\e[31m>>>>>>>> Copying service file <<<<<<<<\e[0m"
cp ${script_path}/user.service /etc/systemd/system/user.service

echo -e "\e[31m>>>>>>>> Starting the service <<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable user 
systemctl restart user

echo -e "\e[31m>>>>>>>> Setup code repo <<<<<<<<\e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[31m>>>>>>>> Installing mongodb <<<<<<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[31m>>>>>>>> Loading the schema <<<<<<<<\e[0m"
mongo --host mongodb-dev.kmvdevops.online </app/schema/user.js

