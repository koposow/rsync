#!/bin/bash

# Путь к исходной директории
SOURCE_DIR="/home/"

# Путь к целевой директории
TARGET_DIR="/tmp/backup/"

# Проверка существования целевой директории
if [ ! -d "$TARGET_DIR" ]; then
    # Создание целевой директории
    mkdir "$TARGET_DIR"
    echo "Целевая директория успешно создана: $TARGET_DIR"
fi

# Выполнение резервного копирования с помощью rsync
rsync -avPh --delete --checksum --exclude=".*" "$SOURCE_DIR" "$TARGET_DIR" >> /var/log/backup.log 2>&1

# Проверка статуса завершения rsync
if [ $? -eq 0 ]; then
  echo "Резервное копирование успешно завершено $(date)" >> /var/log/backup.log
  echo "Копирование успешно выполнено."
else
  echo "Ошибка при выполнении резервного копирования $(date)" >> /var/log/backup.log
  echo "Копирование не удалось."
fi

# Проверка наличия скопированных файлов
if [ -n "$(ls -A "$TARGET_DIR")" ]; then
  echo "Скопированные файлы:"
  ls "$TARGET_DIR"
else
  echo "Нет скопированных файлов."
fi
