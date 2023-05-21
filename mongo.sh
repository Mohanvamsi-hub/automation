script_path = $(dirname $0)
echo ${script_path}

source common.sh
exit

cp /home/centos/automation/mongo.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org -y 
sed -i -e 's|127.0.0.1|0.0.0.0|g' /etc/mongod.conf
systemctl enable mongod 
systemctl restart mongod 