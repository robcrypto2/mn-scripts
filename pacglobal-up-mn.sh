#!/bin/bash
set -e
export LC_ALL="en_US.UTF-8"
binary_url=$2
file_name=$1
extension=".tgz"
#Are the the needed parameters provided?
if [ "$binary_url" = "" ] || [ "$file_name" = "" ]; then
	echo ""
	echo "In order to run this script, you need to add two parameters: first one is the full file name of the wallet on the PAC Global Github, the second one is the full binary url leading to the file on the Github."
	echo "Please check PAC FAQ on the PAC Global website for further information or help!"
	echo ""
	exit
fi
echo ""
echo "#############################################################ä"
echo "#   Welcome to the upgrade script for PACGlobal masternodes  #"
echo "##############################################################"
echo ""
echo "This script is to be ONLY used if the pacglobal-mn.sh script was used to install the PAC masternode version 0.14.x or newer and the masternode is still installed!"
echo ""
if [ -e /root/PACGlobal/pacglobald ]; then
            sleep 1
	else
	    read -p "No files in /root/PACGlobal detected. Are you sure you want to continue [y/n]?" cont
	    if [ $cont = 'n' ] || [ $cont = 'no' ] || [ $cont = 'N' ] || [ $cont = 'No' ]; then
		exit
            fi
fi
sleep 3
echo ""
echo "Running this script on Ubuntu 18.04 LTS or newer is highly recommended."
echo ""
echo "###################################"
echo "#  Updating the operating system  #"
echo "###################################"
echo ""
sleep 3

sudo apt-get -y update
sudo apt-get -y upgrade

echo ""
echo "Stopping the pacg service"
systemctl stop pacg.service || true
echo "The pacg service stopped"
sleep 3

echo ""
echo "#########################################"
echo "#      Getting/Setting binaries up     #"
echo "#########################################"
echo ""
sleep 3
cd ~
set +e
wget $binary_url
set -e
if test -e "$file_name$extension"; then
echo ""
echo "Unpacking PACGlobal distribution"
sleep 3
	tar -xzvf $file_name$extension
	rm -r $file_name$extension
	rm -r -f PACGlobal
	mv -v $file_name PACGlobal
	cd PACGlobal
	chmod +x pacglobald
	chmod +x pacglobal-cli
	echo "Binaries were saved to: /root/PACGlobal"
else
	echo ""
	echo "There was a problem downloading the binaries, please try running the script again."
	echo "Most likely are the parameters used to run the script wrong."
	echo "Please check PAC FAQ on the PAC Global website for further information or help!"
	echo ""
	exit -1
fi
echo ""
echo "Starting the pacg service"
systemctl start pacg.service
echo "The pacg service started"

echo ""
echo "###############################"
echo "#      Running the wallet     #"
echo "###############################"
echo ""
echo "Please wait for 60 seconds!"
echo ""
cd ~/PACGlobal
sleep 60

is_pac_running=`ps ax | grep -v grep | grep pacglobald | wc -l`
if [ $is_pac_running -eq 0 ]; then
	echo ""
	echo "The daemon is not running or there is an issue, please restart the daemon!"
	echo "Please check PAC FAQ on the PAC Global website for further information or help!"
	echo ""
	exit
fi

echo ""
echo "Your masternode / hot wallet binaries have been upgraded!"
echo ""
echo "Please execute following commands to check the status of your masternode:"
echo "~/PACGlobal/pacglobal-cli -version"
echo "~/PACGlobal/pacglobal-cli masternode status"
echo "~/PACGlobal/pacglobal-cli mnsync status"
echo ""


