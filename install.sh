#!/bin/bash

# بررسی اینکه اسکریپت با دسترسی‌های ریشه (root) اجرا می‌شود
if [ "$EUID" -ne 0 ]; then
  echo "لطفاً این اسکریپت را با دسترسی‌های ریشه اجرا کنید (با استفاده از sudo)."
  exit 1
fi

# نام فایل نصب
INSTALL_SCRIPT="install_psiphon.sh"
SERVICE_FILE="/etc/systemd/system/psiphon.service"

# دانلود فایل plinstaller2
echo "دانلود فایل plinstaller2..."
wget https://raw.githubusercontent.com/0fariid0/PsiphonLinux/main/plinstaller2 -O plinstaller2

# بررسی موفقیت دانلود
if [ $? -ne 0 ]; then
  echo "دانلود فایل plinstaller2 شکست خورد."
  exit 1
fi

# اعطای مجوز اجرایی به plinstaller2
chmod +x plinstaller2

# اجرای plinstaller2
echo "اجرای plinstaller2..."
sudo ./plinstaller2

# اجرای Psiphon
echo "اجرای Psiphon..."
sudo psiphon

# ایجاد فایل سرویس
echo "ایجاد فایل سرویس..."
cat > $SERVICE_FILE <<EOL
[Unit]
Description=Psiphon Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/psiphon
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOL

# بارگذاری مجدد سیستم‌دی
echo "بارگذاری مجدد سیستم‌دی..."
systemctl daemon-reload

# فعال‌سازی و شروع سرویس
echo "فعال‌سازی سرویس Psiphon..."
systemctl enable psiphon.service
systemctl start psiphon.service

echo "تمام مراحل با موفقیت انجام شد!"
