#!/usr/bin/env bash

sudo apt-get update

# install pip and virtualenv
sudo apt-get install -y python python-pip git
sudo pip install virtualenv

# install node.js and bower, gulp and yeoman packages
curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g bower gulp yo

# activate virtualenv
mkdir ~/venv && cd $_
virtualenv venv
. venv/bin/activate

# install flask and other python dependencies
pip install -r requirements.txt

# install package.json
cd /vagrant
npm install

# deactivate virtualenv
deactivate
