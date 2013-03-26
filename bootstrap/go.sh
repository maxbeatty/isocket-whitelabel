#!/bin/bash

# copy whitelabel.conf
sudo cp `pwd`/bootstrap/whitelabel.conf /private/etc/apache2/other/whitelabel.conf

ROOT_DIR=`pwd`
ROOT_DIR=${ROOT_DIR//\//\\\/}

sudo sed -i.bak -e s/%%PWD%%/$ROOT_DIR/g /private/etc/apache2/other/whitelabel.conf
sudo rm /private/etc/apache2/other/whitelabel.conf.bak

# update /etc/hosts
if [ `grep -c "whitelabel.dev" /etc/hosts` -eq 0 ]
then
  echo '' | sudo tee -a /etc/hosts
  echo '# via whitelabel' | sudo tee -a /etc/hosts
  echo '127.0.0.1 whitelabel.dev' | sudo tee -a /etc/hosts
fi

# restart apache
sudo apachectl -k restart
