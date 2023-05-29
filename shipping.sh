script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_password=$1

if [ -z $mysql_password ]
then
    echo Input password is missing
    exit 
fi



schema_setup=mysql
component="shipping"
func_java