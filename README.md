
به جنبش آزادی اینترنت بپیوندید.
با تبدیل کردن سرور یا کامپیوتر لینوکس خود به یک دروازه آزادی اینترنت، از مردم سراسر جهان حمایت کنید! با اجرای یک ایستگاه Conduit، بلافاصله به مردم در کشورهای سانسورشده کمک می‌کنید تا به اینترنت آزاد و باز در سراسر جهان دسترسی پیدا کنند. به سادگی Conduit را شروع کنید و تلفن شما افراد را مستقیماً به شبکه Psiphon متصل می‌کند. چه از یک تلفن قدیمی استفاده کنید یا دستگاه

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


---
اسکریپت از شما می‌پرسد:

مسیر دیتا (پیش‌فرض: /var/lib/conduit)

حداکثر کلاینت‌ها (-m)

محدودیت پهنای‌باند Mbps (-b)

سطح لاگ (-v یا -vv)

سقف حجم لاگ سیستم (journald)
---
بررسی وضعیت و لاگ
وضعیت سرویس:

bash
systemctl status conduit -l --no-pager
لاگ زنده:
---

bash
journalctl -fu conduit.service
تنظیمات مهم Conduit
در زمان نصب این گزینه‌ها تنظیم می‌شوند:

-m یا --max-clients: حداکثر تعداد کلاینت هم‌زمان

-b یا --bandwidth: محدودیت مجموع پهنای‌باند (Mbps)

-d یا --data-dir: مسیر ذخیره state/keys

-v / -vv: افزایش سطح لاگ (Verbose/Debug)
---
تغییر تنظیمات بعد از نصب
ویرایش فایل سرویس:

bash
nano /etc/systemd/system/conduit.service
بعد از تغییر:

bash
systemctl daemon-reload
systemctl restart conduit
---
حذف (Uninstall)
اگر فایل uninstall.sh را اضافه کرده‌اید:

bash
sudo -i
./uninstall.sh
---
مسئولیت استفاده
استفاده از این ابزار و مسئولیت‌های شبکه/قانونی و امنیتی با کاربر است. این پروژه صرفاً ابزار نصب و مدیریت سرویس را ارائه می‌دهد.

## نصب سریع

```bash
git clone https://github.com/amirmhs58/conduit-installer-IRAN.git
cd conduit-installer-IRAN
sudo -i
chmod +x conduit-install-universal.sh
./conduit-install-universal.sh
