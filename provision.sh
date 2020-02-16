#!/bin/bash

#assign variables
ACTION=${1}
VERSION=1.0.1

function display_version() {
echo $VERSION
}

function remove_website(){
#Stop Nginx service
sudo service nginx stop

#Delete the files in the website root directory
rm -r /usr/share/nginx/html/*

#Uninstall the Nginx software package
sudo yum remove nginx -y
}

function update_server() {

#Update all system packages
sudo yum update -y

#Install the Nginx software package
sudo amazon-linux-extras install nginx1.12 -y

#Configure nginx to automatically start at system boot up
sudo chkconfig nginx on

#Copy the website documents from s3 to the web document root directory (/usr/share/nginx/html)
sudo aws s3 cp s3://seis665admin-assignment-3/index.html /usr/share/nginx/html/index.html

#Start the Nginx service
sudo service nginx start

}

function display_help() {

cat << EOF
Usage: $0 {-r|--remove|-v|--version|-h|--help} <filename>

OPTIONS:
     -r| --remove Remove Ngnix software and website documents
     -v| --version Display the version of the script
     -h| --help Display the command help

Examples:
     Update system:
          $ ${0}
     Remove files:
          $ ${0} -r
          $ ${0} --remove
     Display version:
          $ ${0} -v
          $ ${0} --version
     Display help:
          $ ${0} -h
          $ ${0} --help
EOF

}

case "$ACTION" in
     -v|--version)
          display_version
          ;;
     -h|--help)
          display_help
          ;;
     -r|--remove)
          remove_website
          ;;
     *)
          update_server
          exit 1
esac
