script = $(realpath "$0")
script_path = $(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[31m>>>>>>>> Setup NodeJS repos <<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[31m>>>>>>>> Installing NodeJS <<<<<<<<\e[0m"
yum install nodejs -y

echo -e "\e[31m>>>>>>>> adding roboshop user <<<<<<<<\e[0m"
useradd roboshop
rm -rf /app
mkdir /app 

echo -e "\e[31m>>>>>>>> Setup code repo <<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip 
cd /app 

echo -e "\e[31m>>>>>>>> unzipping code content <<<<<<<<\e[0m"
unzip /tmp/catalogue.zip

echo -e "\e[31m>>>>>>>> installing nodeJS dependencies <<<<<<<<\e[0m"
npm install 

echo -e "\e[31m>>>>>>>> copying service file <<<<<<<<\e[0m"
cp ${script_path}/catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[31m>>>>>>>> Starting the service <<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable catalogue 
systemctl restart catalogue

echo -e "\e[31m>>>>>>>> copying mongo repo <<<<<<<<\e[0m"
cp ${script_path}/mongo.repo  /etc/yum.repos.d/mongo.repo

echo -e "\e[31m>>>>>>>> Installing mongodb <<<<<<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[31m>>>>>>>> Loading schema <<<<<<<<\e[0m"
mongo --host mongodb-dev.kmvdevops.online </app/schema/catalogue.js

