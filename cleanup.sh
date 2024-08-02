#!/bin/bash

# نام فایل سرویس و فایل‌های مربوطه
SERVICE_FILE="/etc/systemd/system/psiphon.service"
PLINSTALLER_FILE="plinstaller2"

# تابع متوقف کردن و پاک‌سازی سرویس
cleanup_psiphon() {
  # متوقف کردن سرویس
  echo "Stopping Psiphon service..."
  sudo systemctl stop psiphon.service

  # غیرفعال کردن سرویس
  echo "Disabling Psiphon service..."
  sudo systemctl disable psiphon.service

  # حذف فایل سرویس
  if [ -f "$SERVICE_FILE" ]; then
    echo "Removing service file..."
    sudo rm "$SERVICE_FILE"
  else
    echo "Service file not found."
  fi

  # بارگذاری مجدد سیستم‌دی
  echo "Reloading systemd..."
  sudo systemctl daemon-reload

  # حذف فایل plinstaller2
  if [ -f "$PLINSTALLER_FILE" ]; then
    echo "Removing plinstaller2 file..."
    rm "$PLINSTALLER_FILE"
  else
    echo "plinstaller2 file not found."
  fi

  echo "Cleanup completed successfully!"
}

# اجرای تابع
cleanup_psiphon
