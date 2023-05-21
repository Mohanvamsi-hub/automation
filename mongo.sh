script = $(realpath $0)
echo ${script}
exit
source common.sh

cp /home/centos/automation/mongo.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org -y 
sed -i -e 's|127.0.0.1|0.0.0.0|g' /etc/mongod.conf
systemctl enable mongod 
systemctl restart mongod 