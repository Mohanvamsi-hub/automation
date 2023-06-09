app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")
log_file=/tmp/roboshop.log



printhead(){
    echo -e "\e[31m>>>>>>>> $*  <<<<<<<<\e[0m"
    echo -e "\e[31m>>>>>>>> $*  <<<<<<<<\e[0m" &>>$log_file
}

func_stat_check(){
    if [ $1 -eq 0 ]
    then
        echo -e "\e[35m>>>>>> SUCCESS <<<<<<\e[0m"
    else
        echo -e "\e[35m>>>>>> FAILURE <<<<<<\e[0m"
        exit 1
    fi
}

func_schema_setup(){
    if [ "$schema_setup" == "mongo" ]
    then
        printhead "copying mongo repo"
        cp ${script_path}/mongo.repo  /etc/yum.repos.d/mongo.repo &>>$log_file
        func_stat_check $?

        printhead "Installing mongodb"
        yum install mongodb-org-shell -y &>>$log_file
        func_stat_check $?

        printhead "Loading schema"
        mongo --host mongodb-dev.kmvdevops.online </app/schema/${component}.js &>>$log_file
        func_stat_check $?
    fi
    if [ "$schema_setup" == "mysql" ]
    then
        printhead "Installing mysql"
        yum install mysql -y  &>>$log_file
        mysql -h mysql-dev.kmvdevops.online -uroot -p${mysql_password} < /app/schema/${component}.sql &>>$log_file
        func_stat_check $?
    fi
}


func_app_prereq(){
    
    printhead "Adding rboshop user"

    id ${app_user} &>>$log_file
    if [ $? -ne 0 ]
    then
        useradd ${app_user} &>>$log_file
    fi 
    func_stat_check $?

    printhead "creating a diretory"
    rm -rf /app
    mkdir /app &>>$log_file
    func_stat_check $?

    printhead "downloading code content"
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file
    func_stat_check $?

    printhead "unzipping content in app dir"
    cd /app 
    unzip /tmp/${component}.zip &>>$log_file
    func_stat_check $?
}

func_systemd_setup(){

    cp ${script_path}/${component}.service /etc/systemd/system/${component}.service &>>$log_file
    func_stat_check $?

    printhead "starting the service"
    systemctl daemon-reload
    systemctl enable ${component} 
    systemctl restart ${component}
    func_stat_check $?

}

func_nodejs(){

    printhead "Setup NodeJS repo"
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file
    func_stat_check $?

    printhead "Installing nodejs"
    yum install nodejs -y &>>$log_file
    func_stat_check $?

    func_app_prereq

    printhead "Installing nodejs dependancies"
    npm install &>>$log_file
    func_stat_check $?

    func_systemd_setup
    func_schema_setup
}


func_java(){
    
    printhead "Installing Maven"
    yum install maven -y &>>$log_file
    func_stat_check $?
    
    func_app_prereq

    printhead "downloading dependencies"
    mvn clean package &>>$log_file
    mv target/${component}-1.0.jar ${component}.jar &>>$log_file
    func_stat_check $?

    func_systemd_setup

}

func_python(){
    printhead "Install python"
    yum install python36 gcc python3-devel -y &>>$log_file
    func_stat_check $?

    func_app_prereq

   
    printhead "Install python dependencies"
    pip3.6 install -r requirements.txt &>>$log_file
    func_stat_check $?
   
    printhead "copying service file"
    sed -i -e "s|rabbitmq_user_password|${rabbitmq_user_password}|" ${script_path}/${component}.service &>>$log_file
    func_stat_check $?

    cp ${script_path}/${component}.service /etc/systemd/system/${component}.service &>>$log_file
    func_stat_check $?

    printhead "Starting the service"
    func_systemd_setup
    func_stat_check $?
}