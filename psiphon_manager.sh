#!/bin/bash

# فایل سرویس برای Psiphon
SERVICE_FILE="/etc/systemd/system/psiphon.service"

# دانلود فایل plinstaller2
echo "دانلود فایل plinstaller2..."
wget https://raw.githubusercontent.com/0fariid0/PsiphonLinux/main/plinstaller2 -O plinstaller2

# اجرای plinstaller2
echo "اجرای plinstaller2..."
sudo sh plinstaller2

# اجرای Psiphon
echo "اجرای Psiphon..."
sudo psiphon

# ایجاد فایل سرویس
echo "ایجاد فایل سرویس..."
sudo bash -c "cat > $SERVICE_FILE <<EOL
[Unit]
Description=Psiphon Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/psiphon
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOL"

# بارگذاری مجدد سیستم‌دی
echo "بارگذاری مجدد سیستم‌دی..."
sudo systemctl daemon-reload

# فعال‌سازی و شروع سرویس
echo "فعال‌سازی سرویس Psiphon..."
sudo systemctl enable psiphon.service
sudo systemctl start psiphon.service

echo "تمام مراحل با موفقیت انجام شد!"
