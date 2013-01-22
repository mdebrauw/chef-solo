#!/bin/bash

# This runs as root on the server
chef_binary=$(which chef-solo)

# No chef installed?
if ! test -f "$chef_binary"; then
    export DEBIAN_FRONTEND=noninteractive

    # Upgrade headlessly (this is only safe-ish on vanilla systems)
    aptitude update &&
    apt-get -o Dpkg::Options::="--force-confnew" \
        --force-yes -fuy dist-upgrade &&

    # Install Ruby 1.9.3 and Chef 10.16.4
    aptitude install -y ruby1.9.3 make &&
    sudo gem install --no-rdoc --no-ri chef --version 10.16.4

    # Re-set chef_binary if chef-solo wasn't installed first time round
    chef_binary=$(which chef-solo)
fi &&

"$chef_binary" -c solo.rb -j node.json
