#!/bin/sh

set -u -e
scriptpath=`dirname $0`
scriptpath=`(cd "$scriptpath"; /bin/pwd)`
SUDOPROMPT="[sudo for installing vagrant] password for $USER: "

virtualbox_installed=0
for pkg in `echo 'virtualbox ansible curl'`; do
    echo "Checking if $pkg is installed"
    installed=$(dpkg-query -W -f='${Status}' $pkg 2>/dev/null | grep -c "ok installed" || true)
    if [ $installed -eq 0 ]; then
        echo "Installing $pkg"
        sudo --prompt="[sudo for installing $pkg] password for $USER: " apt-get install -y $pkg
        if [ "$pkg" == "virtualbox" ]; then
            virtualbox_installed=1
        fi
    fi
done

installed=$(dpkg-query -W -f='${Status}' vagrant 2>/dev/null | grep -c "ok installed" || true)
if [ $installed -eq 0 ]; then
    echo "Downloading Debian x86_64 Vagrant 1.8.1 debian package"
    cd /tmp
    sudo -v --prompt="[sudo for installing vagrant] password for $USER: "
    curl -O http://192.168.1.12/downloads/vagrant_1.8.1_x86_64.deb
    echo "Installing vagrant"
    sudo dpkg -i vagrant_1.8.1_x86_64.deb
fi

if [ "$virtualbox_installed" > 0 ]; then
    echo "Virtualbox was installed. Please reboot before using vagrant, otherwise your session will hang at \"Booting VM\""
    echo "Once you reboot, start your vagrant dev environment by running the following anywhere at or below the path with this file:"
else
    echo "Ok, now to start your vagrant dev environment, just run the following anywhere at or below the path with this file:"
fi

echo "  $ vagrant up"
