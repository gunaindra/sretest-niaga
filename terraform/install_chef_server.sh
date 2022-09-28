#!/bin/bash
sudo yum -y install git vim wget curl

if [ ! -f /usr/bin/chef-server-ctl ]; then
    echo "<<installing chef-server>>"
    sudo wget https://packages.chef.io/files/stable/chef-server/15.1.7/el/7/chef-server-core-15.1.7-1.el7.x86_64.rpm
    sudo rpm -Uvh chef-server-core-15.1.7-1.el7.x86_64.rpm 
    sudo chef-server-ctl reconfigure --chef-license accept
fi

if [ ! -f /usr/bin/chef-manage-ctl ]; then
    sudo chef-server-ctl install chef-manage
    sudo chef-manage-ctl reconfigure
fi

sudo chef-server-ctl user-create indraguna Indra Guna indraguna4@gmail.com 'plokijuh890-MNB' --filename /home/indraguna/indraguna.pem
sudo chef-server-ctl org-create sretest 'SRE TEST Niagahoster' --association_user indraguna --filename /home/indraguna/sretest-validator.pem


