#!/bin/bash

# setup ssl

# whitelabel
echo "===================="
echo "**NOTE** Just use 'password' for your pass phrase. They will be removed automatically."
echo "**NOTE** For 'Common Name' use *.whitelabel.dev."
echo "**NOTE** For everything else, use the default by pressing enter."
echo "===================="
read -p "Press any key to continue..."

openssl genrsa -des3 -out whitelabel.key 1024

cp whitelabel.key whitelabel.key.copy
openssl rsa -in whitelabel.key.copy  -out whitelabel.key
rm whitelabel.key.copy

openssl req -new -key whitelabel.key -out whitelabel.csr
openssl x509 -req -days 9999 -in whitelabel.csr -signkey whitelabel.key -out whitelabel.crt

# put in place
sudo mkdir /etc/apache2/cert
sudo mv whitelabel.* /etc/apache2/cert

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
  echo '127.0.0.1 whitelabel.dev f.dev' | sudo tee -a /etc/hosts
fi

# restart apache
sudo apachectl -k restart
