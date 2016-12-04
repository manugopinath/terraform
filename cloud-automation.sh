#!/bin/bash
if [ "$#" -ne 4 ]; then
 echo "\nUsage $0 <app> <environment> <num_servers> <server_size>\n"
 echo "eg : $0 wordpress dev 2 m1.small\n"
 exit 1
fi
app=$1
if [ $app != "wordpress" ]; then
 exit 1
fi
  
env=$2
if [ $env != "dev" ]; then
 exit 1
fi
num_servers=$3
server_size=$4

count=$num_servers

sed -i -e "s/.*default =.*/default = $count/" variable.tf
sed -i -e "s/.*instance_type.*/instance_type = \"$server_size\"/" main.tf
/usr/bin/terraform apply
echo -e "[all]" "\n" `cat public_ips.txt` > /etc/ansible/hosts
elb=`terraform show | grep -i elb.amazonaws.com | cut -d"=" -f2`
host $elb | awk '{print $NF}' > elb.txt
echo "elb IP"
cat elb.txt
DB_host=`/usr/bin/terraform show | grep -i endpoint | cut -d":" -f1 | cut -d"=" -f2`
sed -i -e "s/.*DB_host :.*/DB_host : \"$DB_host\"/" /home/manu/terraform/myapp/roles/docker/vars/main.yml
/usr/bin/ansible-playbook infra.yml

