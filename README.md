# Conduit Installer (Ubuntu) | نصب Conduit روی اوبونتو (بدون Docker)

این پروژه یک اسکریپت **نصب و راه‌اندازی خودکار** برای اجرای Conduit (از تیم Psiphon) روی Ubuntu به صورت Native (بدون Docker) فراهم می‌کند. [web:20]  
Conduit به دستگاه/سرور شما اجازه می‌دهد به عنوان یک «نقطهٔ اتصال امن» در شبکهٔ Psiphon عمل کند و به عبور ترافیک رمزنگاری‌شده کاربران در شرایط سانسور کمک کند. [web:210]

---

## ویژگی‌ها
- تشخیص خودکار معماری CPU (ARM64 و AMD64)
- دانلود باینری مناسب و نصب در `/usr/local/bin/conduit`
- ساخت سرویس `systemd` برای اجرای دائمی و Auto-Restart
- استفاده از Data Directory پایدار (برای حفظ state و کلیدها)
- محدودسازی حجم لاگ‌های `journald` و نگه‌داری تا ۷ روز (مدیریت فضای دیسک) [web:166]

---

## پیش‌نیازها
- Ubuntu با دسترسی `root` (یا `sudo -i`)
- اینترنت برای دانلود باینری از GitHub Releases
- باز بودن پورت‌ها/فایروال مطابق تنظیمات شبکه شما

---

## نصب سریع

```bash
git clone https://github.com/amirmhs58/conduit-installer-IRAN.git
cd conduit-installer-IRAN
sudo -i
chmod +x conduit-install-universal.sh
./conduit-install-universal.sh
