set +e
export LC_ALL="en_US.UTF-8"

bd=$(tput bold)
nl=$(tput sgr0)
sync_status=""

echo ""
tput bold 
echo "##########################################################"
echo "#   Welcome to the PACGlobal masternode report script!   #"
echo "##########################################################"
echo ""
tput sgr0
sleep 3
curr_eu_expl="UNKNOWN"
curr_us_expl="UNKNOWN"
curr_block="UNKNOWN"
echo "${bd}What is the status of the pacg.service (if it exists)?${nl}"
systemctl status pacg.service --no-pager --full
echo ""
echo "${bd}Is the pacglobald process running?${nl}"
ps aux|grep pacglobal|grep -v grep
is_pac_running=`ps ax | grep -v grep | grep pacglobal | wc -l`
if [ $is_pac_running -eq 0 ]; then
	echo "${bd}The process is not running!${nl}"
fi
echo ""
echo "${bd}The current memory usage of the system is:${nl}"
free -h
echo ""
echo "${bd}The current disk usage (abbreviated, virtual only) of the system is:${nl}"
df|grep "^/dev/v"
echo ""
echo "${bd}The masternode status (abbreviated) is:${nl}"
~/PACGlobal/pacglobal-cli masternode status|grep '"PoSePenalty":'
~/PACGlobal/pacglobal-cli masternode status|grep -A1 '"state":'
echo ""
echo "${bd}The masternode synchronisation status is:${nl}"
sync_status=$(~/PACGlobal/pacglobal-cli mnsync status|grep -A6 '"AssetID":')
if [ "$sync_status" = "" ]; then
	echo ""
	echo "${bd}The masternode wallet is not running or not properly configured!${nl}"
	else
	~/PACGlobal/pacglobal-cli mnsync status|grep -A6 '"AssetID":'
fi
echo ""
time=$(date)"; "$(uptime -p)
echo "${bd}The current (up)time is: ${nl}"$time
echo ""
curr_block=$(~/PACGlobal/pacglobal-cli getblockcount)
curr_us_expl=$(wget -T 3 -qO- http://usa.pacglobalexplorer.com/api/getblockcount)
curr_eu_expl=$(wget -T 3 -qO- http://eu.pacglobalexplorer.com/api/getblockcount)
echo "${bd}The current block this masternode is on: ${nl}"$curr_block
echo "${bd}The current block the US explorer is on: ${nl}"$curr_us_expl
echo "${bd}The current block the EU explorer is on: ${nl}"$curr_eu_expl
echo ""
wallet_version=$(~/PACGlobal/pacglobal-cli -version)
echo "${bd}The masternode wallet version is: ${nl}"$wallet_version
echo ""
echo "${bd}The script has ended!${nl}"
echo ""
