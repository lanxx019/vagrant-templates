#!/usr/bin/env bash

# https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu-14-04

# variables
MYSQL_PASSWORD="password"
HELP="Install LAMP stack on Ubuntu 14.04. -p allow you to set the root password for MySQL, default is password."

# command line options
while getopts :p:h FLAG; do
  case $FLAG in
      p) 
          echo "Setting MySQL root password to $OPTARG"
          MYSQL_PASSWORD=$OPTARG
          ;;
      h) 
          echo $HELP
          ;;
  esac
done

apt-get update
# util pacakges
apt-get install unzip

echo "********** Installing Apache2 **********"
apt-get install -y apache2

echo "********** Installing MySQL **********"
apt-get install -y debconf-utils
debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_PASSWORD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_PASSWORD"
apt-get install -y mysql-server php5-mysql

echo "********** Configuring MySQL **********"
mysql_install_db
mysql_secure_installation <<-FILE
    $MYSQL_PASSWORD
    n
    y
    y
    y
    y
FILE

echo "********** Installing PHP **********"
apt-get install -y php5 libapache2-mod-php5 php5-mcrypt php5-gd php5-curl libssh2-php

echo "********** Finish installing LAMP **********"

