#!/system/bin/sh
### FDE.AI v4 | FeraVolt. 2019 ###
echo "fde_ai">/sys/power/wake_lock;
while true; do
BOOT=$(getprop sys.boot_completed);

if [ "$BOOT" -eq "1" ];then
sleep 9;
break;
else
sleep 3;
fi;
done;

if [ -e /system/etc/fde.ai/i.sh ];then
/system/etc/fde.ai/i.sh;
rm -f /system/etc/fde.ai/i.sh;
fi;

B=/system/etc/fde.ai/busybox;
mount -o remount,rw /;
mount -o remount rw /;
$B mount -o remount,rw /;
$B killall ai.so;
$B killall aii.so;
$B rm -Rf /fde.ai;
$B mkdir /fde.ai;
mount -t tmpfs -o size=6M tmpfs /fde.ai;
$B mount -t tmpfs -o size=6M tmpfs /fde.ai;
$B sleep 0.5;if [ ! -e /bin/sh ];then 
$B rm -Rf /bin;
$B ln -s /system/bin /bin;
$B ln -s /system/bin/sh /bin/sh;
fi;

$B cp -f /system/etc/fde.ai/busybox /fde.ai/busybox;
$B chmod 777 /fde.ai/*;
$B sleep 0.5;
B=/fde.ai/busybox;
$B unzip -o /system/etc/fde.ai/f -d /fde.ai/;
$B base64 -d /fde.ai/r>>/fde.ai/u;
$B rm -f /fde.ai/r;
$B base64 -d /fde.ai/u>>/fde.ai/ss;
$B rm -f /fde.ai/u;
$B unzip -o /fde.ai/ss -d /fde.ai/;
$B sleep 0.5;
$B rm -f /fde.ai/ss;
$B unzip -o /fde.ai/s/rr -d /fde.ai/s/;
$B rm -f /fde.ai/s/rr;
$B chmod 777 /fde.ai/s;
$B chmod 777 /fde.ai/s/rre.sh;

if [ -e /data/fprop ];then
while IFS='' read -r p;do 
setprop $($B echo "$p");
done</data/fprop;
fi;

$B sleep 0.5;
$B setsid /fde.ai/s/key.txt & $B sleep 69;
$B killall rre.sh;
$B killall key.txt;
$B rm -f /fde.ai/s/rre.sh;
$B rm -f /fde.ai/s/key.txt;
echo "fde_ai">/sys/power/wake_unlock;
mount -o remount,ro /;
mount -o remount ro /;
$B mount -o remount,ro /;