sample_func(){
echo location is $0
echo first arg is $1
echo second arg is $2
echo all args is $*
echo count of args is $#
}


student=$1
money=$2

if [ -z $student ]
then
    echo Input is missing
fi 


if [ ${student} == "vamsi" ]
then
    echo student name is ${student}, he has ${money} in his pocket
else
    echo student name is ${student}, he has no in his pocket
fi 








