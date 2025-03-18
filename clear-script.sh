#!/system/bin/sh
MODDIR=${0%/*}

# Путь к блоку с логами
LOG_FILE="/data/adb/modules/PRUF/logs/script.log"
BLACK_LIST="/data/adb/modules/PRUF/blacklist.conf"
TIME=600

# Логируем старт
echo "$(date): PRUF is running." >> $LOG_FILE

# Бесконечный цикл
while true; do
	# Очищаем лог файл
	# > $LOG_FILE
	# Проверяем наличие файла со списком
	if [ -f "$BLACK_LIST" ]; then
		echo "$(date): $BLACK_LIST found. Starting processing..." >> $LOG_FILE
		
		# Счётчики удалённых файлов и папок
		FILE_COUNT=0
		DIR_COUNT=0
		
		# Читаем файл и удаляем указанные пути
		while IFS= read -r line || [ -n "$line" ]; do
			# Пропускаем пустые строки и строки с комментариями
			if [ -n "$line" ] && [ "${line:0:1}" != "#" ]; then
				if [ -f "$line" ]; then
					rm -f "$line"
					FILE_COUNT=$((FILE_COUNT + 1))
					echo "$(date): File $line deleted." >> $LOG_FILE
				elif [ -d "$line" ]; then
					rm -rf "$line"
					DIR_COUNT=$((DIR_COUNT + 1))
					echo "$(date): Folder $line deleted." >> $LOG_FILE
				fi
			fi
		done < "$BLACK_LIST"
		
		# Итоговые результаты
		echo "$(date): Deleted Files: $FILE_COUNT, Folders: $DIR_COUNT." >> $LOG_FILE
		sed -i "/^description=/c description=Status: Active ✅ [ Deleted Files: $FILE_COUNT | Folders: $DIR_COUNT] Cleaning timer: $TIME sec. 🕓" "$MODDIR/module.prop"
	else
		echo "$(date): The module is disabled, $BLACK_LIST missing." >> $LOG_FILE
		sed -i "/^description=/c description=Status: Inactive ❌ $BLACK_LIST missing." "$MODDIR/module.prop"
		exit 1
	fi
    sleep $TIME
done