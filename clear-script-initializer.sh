#!/system/bin/sh

MODDIR=${0%/*}

PROCESS()
{
	ps -ef | grep "clear-script.sh" | grep -v grep | wc -l
}

while :
do
	if [[ ! -f $MODDIR/disable ]]; then
		if [[ $(PROCESS) -eq 0 ]]; then
			nohup sh $MODDIR/clear-script.sh &
            echo "$(date): PRUF initialized..." >> /data/adb/modules/PRUF/logs/script.log
		fi
	else
		if [[ $(PROCESS) -ne 0 ]]; then
			kill -9 $(ps -ef | grep clear-script.sh | grep -v grep | awk '{ print $2 }')
			[[ $? == 0 ]] && sed -i "/^description=/c description=Status: Inactive ❌ Module disabled manually (activate without rebooting)." "$MODDIR/module.prop"
            echo "$(date): PRUF has been stopped..." >> /data/adb/modules/PRUF/logs/script.log
        fi
	fi
	sleep 5
done