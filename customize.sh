SKIPUNZIP=0

get_choose()
{
	local choose
	local branch
	while :; do
		choose="$(getevent -qlc 1 | awk '{ print $3 }')"
		case "$choose" in
		KEY_VOLUMEUP)  branch="0" ;;
		KEY_VOLUMEDOWN)  branch="1" ;;
		*)  continue ;;
		esac
		echo "$branch"
		break
	done
}

MyPrint() 
{
	echo "$@"
	sleep 0.03
}
MyPrint "(!) Installation Instructions:"
MyPrint "- After installation and reboot, all hidden folders/files (starting with '.') in the /sdcard directory will be deleted by default, along with other unnecessary folders"
MyPrint "- Ensure there is no important data in hidden folders in the /sdcard directory. If there is, back it up before installation"
MyPrint " "
MyPrint "(?) Confirm installation? (Choose)"
MyPrint "- Press Volume Up: Install √"
MyPrint "- Press Volume Down: Exit ✕"
if [[ $(get_choose) == 0 ]]; then
	MyPrint "- Installation selected"
	MyPrint " "
	if [[ -f /sdcard/Android/blacklist.conf ]]; then
		MyPrint "- Old rule file detected. Keep the old rule file? (Choose)"
		MyPrint "- Press Volume Up: Keep"
		MyPrint "- Press Volume Down: Replace"
		if [[ $(get_choose) == 1 ]]; then
			MyPrint "- Replace selected, backing up the old rule file"
			cat /sdcard/Android/blacklist.conf > "/sdcard/Android/$(date "+%T")-backup-blacklist.conf"
			MyPrint "- Backup saved to /sdcard/Android/$(date "+%T")-backup-blacklist.conf"
			rm -rf /sdcard/Android/blacklist.conf
			MyPrint "- Old file deleted"
			cp -af $MODPATH/files/blacklist.conf /sdcard/Android/
			MyPrint "- New file created"
			MyPrint " "
		else
			MyPrint "- Keep old rule file selected"
			MyPrint " "
		fi
	else
		MyPrint "- Creating rule file in /sdcard/Android/. After reboot, check the directory for blacklist.conf"
		MyPrint " "
		cp -af $MODPATH/files/blacklist.conf /sdcard/Android/
	fi
	if [[ -d /data/adb/modules/PRUF/files/*/ ]]; then
		MyPrint "- Record information detected"
		cp -af /data/adb/modules/PRUF/files/*/ $MODPATH/files/
		MyPrint "- Information copied"
		MyPrint " "
	fi
    mkdir -p /data/adb/modules/PRUF/logs/
    echo "$(date): PRUF has been installed." >> /data/adb/modules/PRUF/logs/script.log
else
	abort "- Exit selected"
fi
