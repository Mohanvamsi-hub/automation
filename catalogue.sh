script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

component=catalogue

echo -e "\e[31m>>>>>>>> copying mongo repo <<<<<<<<\e[0m"
cp ${script_path}/mongo.repo  /etc/yum.repos.d/mongo.repo

echo -e "\e[31m>>>>>>>> Installing mongodb <<<<<<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[31m>>>>>>>> Loading schema <<<<<<<<\e[0m"
mongo --host mongodb-dev.kmvdevops.online </app/schema/catalogue.js

