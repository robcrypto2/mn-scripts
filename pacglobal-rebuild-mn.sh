#!/bin/bash

set -e

export LC_ALL="en_US.UTF-8"

echo ""
echo "######################################################################"
echo "#   Welcome to the chain clean-up script for PACGlobal masternodes   #"
echo "######################################################################"
echo ""
echo "This script is to be ONLY used if the pacglobal-mn.sh script was used to install the PAC masternode version 0.14.x or newer and the masternode is still installed!"
echo ""
if [ -e /root/.PACGlobal/pacglobal.conf ]; then
            sleep 1
	else
	    read -p "No pacglobal.conf in /root/.PACGlobal folder detected. Are you sure you want to continue [y/n]?" cont
	    if [ $cont = 'n' ] || [ $cont = 'no' ] || [ $cont = 'N' ] || [ $cont = 'No' ]; then
		exit
            fi
fi
sleep 3
echo ""
echo "###################################"
echo "#  Updating the operating system  #"
echo "###################################"
echo ""
echo "Running this script on Ubuntu 18.04 LTS or newer is highly recommended."
echo ""
sleep 3

sudo apt-get -y update
sudo apt-get -y upgrade

echo ""
echo "Stopping the pacg service"
systemctl stop pacg.service
echo "The pacg service stopped"
sleep 3

echo ""
echo "########################################"
echo "#    Removing the current chain data   #"
echo "########################################"
echo ""
sleep 3
cd ~
rm -f .PACGlobal/banlist.dat
rm -f .PACGlobal/fee_estimates.dat
rm -f .PACGlobal/governance.dat
rm -f .PACGlobal/instantsend.dat
rm -f .PACGlobal/mempool.dat
rm -f .PACGlobal/mncache.dat
rm -f .PACGlobal/netfulfilled.dat
rm -f .PACGlobal/pacglobal.pid
rm -f .PACGlobal/peers.dat
rm -f .PACGlobal/sporks.dat
rm -f .PACGlobal/*.log
rm -r -f .PACGlobal/blocks
rm -r -f .PACGlobal/chainstate/
rm -r -f .PACGlobal/database/
rm -r -f .PACGlobal/evodb/
rm -r -f .PACGlobal/llmq/
echo "Clean-up done!"
echo ""
#The three commands below should not be needed!
cd .PACGlobal
set +e
wget -q https://github.com/PACGlobalOfficial/mn-scripts/blob/master/peers.dat?raw=true
mv peers.dat?raw=true peers.dat
set -e
sleep 3
echo "Starting the pacg service"
systemctl start pacg.service
echo "The pacg service started"

echo ""
echo "###############################"
echo "#      Running the wallet     #"
echo "###############################"
echo ""
echo "Please wait for 60 seconds!"
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
echo "Your masternode / hot wallet has started rebuilding the local copy of blockchain!"
echo ""
echo "Please execute following commands to check the status of your masternode:"
echo "~/PACGlobal/pacglobal-cli -version"
echo "~/PACGlobal/pacglobal-cli masternode status"
echo "~/PACGlobal/pacglobal-cli mnsync status"
echo ""
