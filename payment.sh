script = $(realpath "$0")
script_path = $(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[31m >>>>>>>> Install python <<<<<<<<\e[0m"
yum install python36 gcc python3-devel -y

echo -e "\e[31m >>>>>>>> Adding roboshop user <<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[31m >>>>>>>> creating app dir <<<<<<<<\e[0m"
rm -rf /app
mkdir /app 

echo -e "\e[31m >>>>>>>> Downloading and unzipping app code <<<<<<<<\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip 
cd /app 
unzip /tmp/payment.zip

echo -e "\e[31m >>>>>>>> Install python dep <<<<<<<<\e[0m"
pip3.6 install -r requirements.txt
cp ${script_path}/payment.service /etc/systemd/system/payment.service

echo -e "\e[31m >>>>>>>> Satrting the service <<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable payment 
systemctl restart payment