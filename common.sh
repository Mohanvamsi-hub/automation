app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")




printhead(){
    echo -e "\e[31m>>>>>>>> $*  <<<<<<<<\e[0m"
}



schema_setup(){
    if [ -z "$schema_setup"=="mongo" ]
    then
        printhead "copying mongo repo"
        cp ${script_path}/mongo.repo  /etc/yum.repos.d/mongo.repo

        printhead "Installing mongodb"
        yum install mongodb-org-shell -y

        printhead "Loading schema"
        mongo --host mongodb-dev.kmvdevops.online </app/schema/${component}.js
    fi
}



func_nodejs(){

printhead "Setup NodeJS repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

printhead "Installing nodejs"
yum install nodejs -y

printhead "Adding user and creating a directory"
useradd ${app_user}
rm -rf /app
mkdir /app 

printhead "Setup code repo"
curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip 

printhead "Moving into the app directory"
cd /app 

printhead "unzipping code content"
unzip /tmp/${component}.zip

printhead "Installing nodejs dependancies"
npm install 

printhead "Copying service file"
cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

printhead "Starting the service"
systemctl daemon-reload
systemctl enable ${component} 
systemctl restart ${component}
schema_setup()

}