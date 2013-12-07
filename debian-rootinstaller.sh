#!/bin/bash
apt-get update
apt-get install -y puppet rubygems;
gem install puppet-module;
mkdir -p /etc/puppet/modules;
cd modules
cp -R * /etc/puppet/modules/
cd ..
puppet apply manifests/init.pp