app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")




printhead(){
    echo -e "\e[31m>>>>>>>> $*  <<<<<<<<\e[0m"
}



func_schema_setup(){
    if [ "$schema_setup" == "mongo" ]
    then
        printhead "copying mongo repo"
        cp ${script_path}/mongo.repo  /etc/yum.repos.d/mongo.repo

        printhead "Installing mongodb"
        yum install mongodb-org-shell -y

        printhead "Loading schema"
        mongo --host mongodb-dev.kmvdevops.online </app/schema/${component}.js
    fi
    if [ "$schema_setup" == "mysql" ]
    then
        printhead "Installing mysql"
        yum install mysql -y 
        mysql -h mysql-dev.kmvdevops.online -uroot -p${mysql_password} < /app/schema/${component}.sql 
    fi
}


func_app_prereq(){
    
printhead "Adding rboshop user"
useradd ${app_user}

printhead "creating a diretory"
rm -rf /app
mkdir /app 

printhead "downloading code content"
curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip 

printhead "unzipping content in app dir"
cd /app 
unzip /tmp/${component}.zip
}

func_systemd_setup(){

cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

printhead "starting the service"
systemctl daemon-reload
systemctl enable ${component} 
systemctl restart ${component}

}

func_nodejs(){

printhead "Setup NodeJS repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

printhead "Installing nodejs"
yum install nodejs -y

func_app_prereq

printhead "Installing nodejs dependancies"
npm install 

func_systemd_setup
func_schema_setup
}


func_java(){
    
printhead "Installing Maven"
yum install maven -y

func_app_prereq

printhead "downloading dependencies"
mvn clean package 
mv target/${component}-1.0.jar ${component}.jar

func_systemd_setup

}