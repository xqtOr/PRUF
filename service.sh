#!/system/bin/sh
MODDIR=${0%/*}

until [[ $(getprop sys.boot_completed) -eq 1 ]]; do
	sleep 2
done

sdcard_rw()
{
	local test_file="/sdcard/Android/.A_TEST_FILE"
	touch $test_file
	while [[ ! -f $test_file ]]; do
		touch $test_file
		sleep 1
	done
	rm $test_file
}

PROCESS()
{
	ps -ef | grep "clear-script-initializer.sh" | grep -v grep | wc -l
}

sdcard_rw

[[ ! -f /sdcard/Android/blacklist.conf ]] && cp -af $MODDIR/files/blacklist.conf /sdcard/Android/

until [[ $(PROCESS) -ne 0 ]]; do
	nohup sh $MODDIR/clear-script-initializer.sh &
	sleep 2
done