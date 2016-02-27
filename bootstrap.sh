#!/usr/bin/env bash

sudo apt-get update

# install pip and virtualenv
sudo apt-get install -y python python-pip git
sudo pip install virtualenv

# install node.js and bower, gulp and yeoman packages
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g bower gulp yo

# activate virtualenv
cd /vagrant
#rm -r venv
virtualenv venv
. venv/bin/activate

# install flask and other python dependencies
pip install -r requirements.txt

# install package.json and bower dependencies
#rm -r node_modules
#npm install

# deactivate virtualenv
deactivate
