set +e
export LC_ALL="en_US.UTF-8"

tput bold 
echo ""
echo "Welcome to the PACGlobal masternode report script!"
echo ""
sleep 3
echo "For how long is the operating system running:"
tput sgr0
uptime
echo ""
tput bold 
echo "What is the status of the pacg.service (if it exists)?"
tput sgr0
systemctl status pacg.service --no-pager --full
echo ""
tput bold 
echo "Is the pacglobald process running?"
tput sgr0
ps aux|grep pacglobal
echo ""
tput bold 
echo "The current memory usage of the operating system is:"
tput sgr0
free -h
echo ""
tput bold 
echo "The masternode synchronisazion status is:"
tput sgr0
~/PACGlobal/pacglobal-cli mnsync status
echo ""
tput bold 
echo "The current date / time is:"
tput sgr0
date
echo ""
tput bold 
echo "The current block the masternode is on:"
tput sgr0
~/PACGlobal/pacglobal-cli getblockcount
sleep 1
echo ""
tput bold 
echo "The masternode wallet version is:"
tput sgr0
~/PACGlobal/pacglobal-cli -version
echo ""
echo "The script has ended!"
echo ""

