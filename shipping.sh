script = $(realpath "$0")
script_path = $(dirname "$script")
source ${script_path}/common.sh

source common.sh
echo -e "\e[31m >>>>>>>>>>> Installing Maven <<<<<<<<<<\e[0m"
yum install maven -y

echo -e "\e[31m >>>>>>>>>>> Adding rboshop user <<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[31m >>>>>>>>>>> creating a diretory <<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app 

echo -e "\e[31m >>>>>>>>>>> downloading code content <<<<<<<<<<\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip 

echo -e "\e[31m >>>>>>>>>>> unzipping content in app dir  <<<<<<<<<<\e[0m"
cd /app 
unzip /tmp/shipping.zip

echo -e "\e[31m >>>>>>>>>>> downloading dependencies <<<<<<<<<<\e[0m"
mvn clean package 
mv target/shipping-1.0.jar shipping.jar

echo -e "\e[31m >>>>>>>>>>> Installing mysql <<<<<<<<<<\e[0m"
yum install mysql -y 
mysql -h mysql-dev.kmvdevops.online -uroot -pRoboShop@1 < /app/schema/shipping.sql 

cp ${script_path}/shipping.service /etc/systemd/system/shipping.service

echo -e "\e[31m >>>>>>>>>>> starting the service <<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable shipping 
systemctl restart shipping