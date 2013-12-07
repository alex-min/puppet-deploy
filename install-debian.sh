#!/bin/bash
apt-get install -y git;
git clone https://github.com/alex-min/puppet-deploy.git ./puppet-deploy;
cd ./puppet-deploy
bash ./debian-rootinstaller.sh
