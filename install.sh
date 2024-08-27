#!/bin/bash

set -e

proxmoxVersion=$(pveversion --verbose| grep proxmox-ve| cut -d" " -f2| cut -d"." -f1 )
currentDirectory=$(pwd)
outputDirectory="/opt/Proxmox-Cloud-Image-Importer"

if ! [ -x "$(command -v git)" ]; then
    echo "Installing Git..." 
    sudo apt-get install git -y
else 
    echo "Git is already installed. Skipping... "
fi


if ! [ -x "$(command -v pip3)" ]; then
    echo "Installing Python3 Pip..." 
    sudo apt-get install python3-pip -y
else 
    echo "Python3 Pip is already installed. Skipping... "
fi

echo "Downloading importer"
git clone https://github.com/ggMartinez/Proxmox-Cloud-Image-Importer $outputDirectory && cd $outputDirectory


echo "Installing requirements"
if [  "$proxmoxVersion" = "7" ]
then 
    pip3 install -r requirements.txt
fi 
if [ "$proxmoxVersion" = "8" ]
then 
    pip3 install -r requirements.txt  --break-system-packages
fi


echo "Creating symlink"
ln -s $outputDirectory/cloud-import.py /usr/bin/cloud-import && chmod +x $outputDirectory/cloud-import.py


echo "Installed!! Run with 'cloud-import'"
echo "If you want to update, run \"cd $outputDirectory && git pull\"."

cd $currentDirectory