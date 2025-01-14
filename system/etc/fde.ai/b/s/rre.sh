#!/system/bin/sh
### FDE.AI v4 | FeraVolt. 2019 ###
B=/fde.ai/busybox;
L=/sdcard/fde.txt;
export PATH=/sbin:/system/sbin:/system/bin:/system/xbin;
$B mount -o remount,rw /data;
mount -o remount,rw /data;
$B mount -t debugfs none /sys/kernel/debug;
mount -t debugfs none /sys/kernel/debug;
$B chmod 0755 /sys/kernel/debug;
$B chmod -R 777 /cache/*;

if [ ! -e /etc/fstab ];then
$B mount -o bind /sbin/.magisk/img/FDE/system/etc/fstab /etc/fstab;
fi;

RUS=$(getprop persist.sys.locale|$B grep -o "ru-");
S=$(getprop ro.build.version.sdk);
R=$($B free -m|$B awk '{ print $2 }'|$B sed -n 2p);
Rfree=$($B free -m|$B awk '{ print $4 }'|$B sed -n 2p);
Ravail=$($B free -m|$B awk '{ print $7 }'|$B sed -n 2p);
A=$(grep -Eo "ro.product.cpu.abi(2)?=.+" /system/build.prop 2>/dev/null|grep -Eo "[^=]*$"|head -n1);

if [ -e /sys/kernel/gpu/gpu_model ];then
GMDL=$($B cat /sys/kernel/gpu/gpu_model);
G=" $GMDL";
else
G=$(dumpsys SurfaceFlinger|$B grep "GLES:"|$B sed -e "s=GLES: =="|$B cut -d "," -f 2);
fi;

if [ -e /sys/kernel/gpu/gpu_max_clock ];then
GMINCLK=$($B cat /sys/kernel/gpu/gpu_min_clock);
GMAXCLK=$($B cat /sys/kernel/gpu/gpu_max_clock);

if [ "$GMAXCLK" -gt "100000" ];then
GMINCLK=$((GMINCLK/1000));GMAXCLK=$((GMAXCLK/1000));
fi;
elif [ -e /sys/class/misc/mali0/device/devfreq/gpufreq/min_freq ];then
GMINCLKK=$($B cat /sys/class/misc/mali0/device/devfreq/gpufreq/min_freq);
GMAXCLKK=$($B cat /sys/class/misc/mali0/device/devfreq/gpufreq/max_freq);
GMINCLK=$((GMINCLKK/1000000));
GMAXCLK=$((GMAXCLKK/1000000));
fi;

if [ -e /sys/devices/system/cpu/cpu9/cpufreq/cpuinfo_max_freq ];then
MAXFR=$($B cat /sys/devices/system/cpu/cpu9/cpufreq/cpuinfo_max_freq);
elif [ -e /sys/devices/system/cpu/cpu7/cpufreq/cpuinfo_max_freq ];then
MAXFR=$($B cat /sys/devices/system/cpu/cpu7/cpufreq/cpuinfo_max_freq);
elif [ -e /sys/devices/system/cpu/cpu3/cpufreq/cpuinfo_max_freq ];then
MAXFR=$($B cat /sys/devices/system/cpu/cpu3/cpufreq/cpuinfo_max_freq);
elif [ -e /sys/devices/system/cpu/cpu1/cpufreq/cpuinfo_max_freq ];then
MAXFR=$($B cat /sys/devices/system/cpu/cpu1/cpufreq/cpuinfo_max_freq);
elif [ -e /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq ];then
MAXFR=$($B cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq);
elif [ -e /sys/devices/system/cpu/cpufreq/cpuinfo_max_freq ];then
MAXFR=$($B cat /sys/devices/system/cpu/cpufreq/cpuinfo_max_freq);
fi;

if [ -e /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_min_freq ];then
MINFR=$($B cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_min_freq);
elif [ -e /sys/devices/system/cpu/cpufreq/cpuinfo_min_freq ];then
MINFR=$($B cat /sys/devices/system/cpu/cpufreq/cpuinfo_min_freq);
fi;

CA=$(dumpsys batterystats|$B grep "Capacity:"|$B cut -d ":" -f 2|$B cut -d "," -f 1|$B sed 's/ //g'|head -n1);
if [ -e /sys/devices/soc0/machine ];then
CFA=$($B cat /sys/devices/soc0/family);
CMA=$($B cat /sys/devices/soc0/machine);
CREV=$($B cat /sys/devices/soc0/revision);
if [ -z "$CMA" ];then
CMA=$($B grep 'Hardware' /proc/cpuinfo|$B cut -d "," -f 2);
fi;
CP=" $CFA $CMA rev $CREV";
else
CP=$($B grep 'Hardware' /proc/cpuinfo|$B cut -d ":" -f 2);
fi;

if [ -e /sys/devices/system/cpu/possible ];then
CPOS=$($B cat /sys/devices/system/cpu/possible|$B cut -d "-" -f 2);
C=$((CPOS+1));
else C=$($B grep -c 'processor' /proc/cpuinfo);
fi;
if [ "$C" = "0" ];then
C=1;
fi;

BTMP=$(dumpsys battery|$B grep "temperature"|$B awk '{ print $2 }'|$B head -1|$B cut -c 1-2);
if [ -z "$BTMP" ];then
BTMP=30;
fi;

if [ -e /sys/devices/system/cpu/cpufreq/scaling_governor ];then
GOV=$($B cat /sys/devices/system/cpu/cpufreq/scaling_governor);

elif [ -e /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ];then
GOV=$($B cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor);
fi;
OSTIME=$($B uptime|$B cut -d "," -f 1|$B cut -d "p" -f 2);
$B rm -f $L;
$B touch $L;
{
 $B echo " ">$L;
 $B echo "       @@@   @@@    @@@   @@@";
 $B echo "       @@@   @@@    @@@   @@@";
 $B echo "       @@@   @@@    @@@   @@@";
 $B echo "      @@@@@@@@@@@@@@@@@@@@@@@@";
 $B echo "@@@@@@@@@@@@@@@@ FDE @@@@@@@@@@@@@@@";
 $B echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@";
 $B echo "      @@@@@@@@   @@@@@@   @@@@";
 $B echo "@@@@@@@@@@@@@     @@@@@   @@@@@@@@@@";
 $B echo "@@@@@@@@@@@@   @   @@@@   @@@@@@@@@@";
 $B echo "      @@@@@@  @@@  @@@@   @@@@";
 $B echo "@@@@@@@@@@@         @@@   @@@@@@@@@@";
 $B echo "@@@@@@@@@@   @@@@@   @@   @@@@@@@@@@";
 $B echo "      @@@@@@@@@@@@@@@@@@@@@@@@";
 $B echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@";
 $B echo "@@@@@@@@@@@@@@@ $(getprop fde_ver) @@@@@@@@@@@@@@";
 $B echo "      @@@@@@@@@@@@@@@@@@@@@@@@";
 $B echo "       @@@   @@@    @@@   @@@";
 $B echo "       @@@   @@@    @@@   @@@";
 $B echo "       @@@   @@@    @@@   @@@";
 $B echo " ";}>>$L;
 
 if [ -n "$RUS" ];then
 { 
 $B echo ">> Устройство: $(getprop ro.product.brand) $(getprop ro.product.model)";
 $B echo ">> Прошивка: $(getprop ro.build.display.id)";
 $B echo ">> Версия ядра: $($B uname -r)";
 $B echo ">> Android SDK: $S";
 $B echo ">> Режим SElinux: $(getenforce)";
 $B echo ">> ЦП:$CP";
 $B echo ">> Архитектура ЦП: $A";
 $B echo ">> Ядра ЦП: $C";
 if [ -n "$MAXFR" ];then
 $B echo ">> Частота ЦП: $((MINFR/1000))-$((MAXFR/1000)) MГц";
 fi;
 $B echo ">> Регулятор ЦП: $GOV";
 $B echo ">> ОЗУ: $R Mб";
 $B echo ">> ОЗУ доступно свободной: $Ravail Mб";
 $B echo ">> ОЗУ реально свободной: $Rfree Mб";
 $B echo ">> Видео-ускоритель:$G";
 if [ -n "$GMINCLK" ];then
 $B echo ">> Частота видео-ускорителя: $GMINCLK-$GMAXCLK МГц";
 fi;
 if [ "$S" -ge "18" ];then
 $B echo ">> Разрешение экрана:$(wm size|$B head -n 1|$B cut -d ":" -f 2)";
 $B echo ">> Плотность пикселей:$(wm density|$B head -n 1|$B cut -d ":" -f 2) dpi";
 fi;
 if [ "$CA" -ne "1000" ];then
 $B echo ">> Емкость батареи: $CA мАч";
 fi;
 $B echo ">> Температура устройства: $BTMP C";
 $B echo ">> Время работы системы:$OSTIME";}>>$L;
 else 
 { 
 $B echo ">> Device: $(getprop ro.product.brand) $(getprop ro.product.model)";
 $B echo ">> ROM: $(getprop ro.build.display.id)";
 $B echo ">> Kernel version: $($B uname -r)";
 $B echo ">> Android SDK: $S";
 $B echo ">> SElinux state: $(getenforce)";
 $B echo ">> CPU:$CP";
 $B echo ">> CPU arch: $A";
 $B echo ">> CPU cores: $C";
 if [ -n "$MAXFR" ];then
 $B echo ">> CPU freq: $((MINFR/1000))-$((MAXFR/1000)) MHz";
 fi;
 $B echo ">> CPU governor: $GOV";
 $B echo ">> RAM: $R MB";
 $B echo ">> RAM available free: $Ravail MB";
 $B echo ">> RAM real free: $Rfree MB";
 $B echo ">> GPU:$G";
 if [ -n "$GMINCLK" ];then
 $B echo ">> GPU freq: $GMINCLK-$GMAXCLK MHz";
 fi;
 if [ "$S" -ge "18" ];then
 $B echo ">> Display size:$(wm size|$B head -n 1|$B cut -d ":" -f 2)";
 $B echo ">> Display density:$(wm density|$B head -n 1|$B cut -d ":" -f 2) dpi";
 fi;
 if [ "$CA" -ne "1000" ];then
 $B echo ">> Battery capacity: $CA mAh";
 fi;
 $B echo ">> Device temperature: $BTMP C";
 $B echo ">> System up time:$OSTIME";}>>$L;
 fi;
 $B echo ">> ROOT: $(su -v)">>$L;
 $B echo ">> $(/fde.ai/busybox|$B head -n 1)">>$L;
 svc power stayon true;
 $B echo " ">>$L;
 if [ -n "$RUS" ];then
 am start -a android.intent.action.MAIN -e message "Запуск FDE.AI - $(getprop fde_ver)" -n com.android.msg/.ShowToast;
 else
 am start -a android.intent.action.MAIN -e message "Starting FDE.AI - $(getprop fde_ver)" -n com.android.msg/.ShowToast;
 fi;
 if [ -n "$RUS" ];then
 $B echo "$(date +%X) - Оптимизация загрузки ОС">>$L;
 else
 $B echo "$(date +%X) - OS boot process optimization">>$L;
 fi;
 sync;
 if [ "$S" -le "26" ];then
 service call activity 51 i32 "$C";
 elif [ "$S" -eq "27" ];then
 service call activity 42 i32 "$C";
 elif [ "$S" -ge "28" ];then
 service call activity 47 i32 "$C";
 fi;
 
 if [ "$S" -le "22" ];then
 if [ -e /sys/fs/selinux/enforce ];then
 supolicy --live "allow mediaserver mediaserver_tmpfs:file { read write execute }";
 supolicy --live "allow audioserver audioserver_tmpfs:file { read write execute }";
 if [ -n "$RUS" ];then
 $B echo "$(date +%X) - Оптимизация параметров SElinux">>$L;
 else 
 $B echo "$(date +%X) - SElinux parameters optimization">>$L;
 fi;
 fi;
 fi;
 if [ -n "$RUS" ];then
 $B echo "$(date +%X) - Оптимизация среды выполнения">>$L;
 else 
 $B echo "$(date +%X) - Runtime environment optimization">>$L;
 fi;
 $B unzip -o /fde.ai/s/aa -d /fde.ai/s/;
 $B unzip -o /fde.ai/s/ai -d /fde.ai/s/;
 $B unzip -o /fde.ai/s/aii -d /fde.ai/s/;
 $B unzip -o /fde.ai/s/bb -d /fde.ai/s/;
 $B unzip -o /fde.ai/s/cc -d /fde.ai/s/;
 $B unzip -o /fde.ai/s/dd -d /fde.ai/s/;
 $B unzip -o /fde.ai/s/ee -d /fde.ai/s/;
 $B unzip -o /fde.ai/s/ff -d /fde.ai/s/;
 $B unzip -o /fde.ai/s/gg -d /fde.ai/s/;
 $B unzip -o /fde.ai/s/hh -d /fde.ai/s/;
 $B unzip -o /fde.ai/s/ii -d /fde.ai/s/;
 $B unzip -o /fde.ai/s/libfde -d /fde.ai/s/;
 $B rm -f /fde.ai/s/aa;
 $B rm -f /fde.ai/s/ai;
 $B rm -f /fde.ai/s/aii;
 $B rm -f /fde.ai/s/bb;
 $B rm -f /fde.ai/s/cc;
 $B rm -f /fde.ai/s/dd;
 $B rm -f /fde.ai/s/ee;
 $B rm -f /fde.ai/s/ff;
 $B rm -f /fde.ai/s/gg;
 $B rm -f /fde.ai/s/hh;
 $B rm -f /fde.ai/s/ii;
 $B rm -f /fde.ai/s/libfde;
 $B base64 -d /fde.ai/s/aa.bin>>/fde.ai/s/aa.so;
 $B base64 -d /fde.ai/s/ai.bin>>/fde.ai/s/ai.so;
 $B base64 -d /fde.ai/s/aii.bin>>/fde.ai/s/aii.so;
 $B base64 -d /fde.ai/s/bb.bin>>/fde.ai/s/bb.so;
 $B base64 -d /fde.ai/s/cc.bin>>/fde.ai/s/cc.so;
 $B base64 -d /fde.ai/s/dd.bin>>/fde.ai/s/dd.so;
 $B base64 -d /fde.ai/s/ee.bin>>/fde.ai/s/ee.so;
 $B base64 -d /fde.ai/s/ff.bin>>/fde.ai/s/ff.so;
 $B base64 -d /fde.ai/s/gg.bin>>/fde.ai/s/gg.so;
 $B base64 -d /fde.ai/s/hh.bin>>/fde.ai/s/hh.so;
 $B base64 -d /fde.ai/s/libfde.bin>>/fde.ai/s/libfde.so;
 $B chmod 777 /fde.ai/s/*.so;
 $B rm -f /fde.ai/s/*.bin;
 /fde.ai/s/aa.so>/dev/null 2>&1;
 $B rm -f /fde.ai/s/aa.so;
 $B setsid /fde.ai/s/bb.so & /fde.ai/s/cc.so>/dev/null 2>&1;
 $B rm -f /fde.ai/s/cc.so;
 $B setsid /fde.ai/s/dd.so & /fde.ai/s/ee.so>/dev/null 2>&1;
 $B rm -f /fde.ai/s/ee.so;
 if [ -n "$RUS" ];then
 $B echo "$(date +%X) - Запуск ИИ..">>$L;
 else
 $B echo "$(date +%X) - Starting AI..">>$L;
 fi;
 $B setsid /fde.ai/s/ai.so & aiso=$($B pidof ai.so);
 $B renice -1 "$aiso";
 /fde.ai/s/ff.so>/dev/null 2>&1;
 $B rm -f /fde.ai/s/ff.so;
 /fde.ai/s/gg.so>/dev/null 2>&1;
 $B rm -f /fde.ai/s/gg.so;
 /fde.ai/s/hh.so>/dev/null 2>&1;
 $B rm -f /fde.ai/s/hh.so;
 if [ -n "$RUS" ];then
 $B echo "$(date +%X) - Проверка всех разделов на ошибки..">>$L;
 else 
 $B echo "$(date +%X) - Checking errors on all partitions..">>$L;
 fi;
 $B fsck -A -C -V -T;
 if [ "$S" -le "26" ];then
 service call activity 51 i32 -1;
 elif [ "$S" -le "27" ];then
 service call activity 42 i32 -1;
 elif [ "$S" -ge "28" ];then
 service call activity 47 i32 -1;
 fi;
 if [ "$S" -le "20" ];then
 setprop dalvik.vm.dexopt-flags m=y,v=n,o=v;
 if [ -n "$RUS" ];then
 $B echo "$(date +%X) - Оптимизация DalvikVM">>$L;
 else
 $B echo "$(date +%X) - DalvikVM optimization">>$L;
 fi;
 fi;
 
 if [ "$S" -le "18" ];then
 if [ "$S" -gt "10" ];then
 $B sleep 9;
 $B killall -9 android.process.media;
 $B killall -9 mediaserver;
 $B killall -9 com.google.android.gms.persistent;
 am kill-all;
 
 if [ -n "$RUS" ];then
 $B echo "$(date +%X) - Исправление системных процессов">>$L;
 else 
 $B echo "$(date +%X) - System services fixes">>$L;
 fi;
 fi;
 else
 am kill-all;
 if [ -n "$RUS" ];then
 $B echo "$(date +%X) - Оптимизация распределения памяти DalvikVM">>$L;
 else
 $B echo "$(date +%X) - DalvikVM memory allocation optimization">>$L;
 fi;
 if [ "$R" -le "3072" ];then
 setprop dalvik.vm.heapminfree 2m;
 else
 setprop dalvik.vm.heapminfree 8m;
 fi;
 if [ "$S" -gt "23" ];then
 if [ -n "$RUS" ];then
 $B echo "$(date +%X) - Патч SafetyNET">>$L;
 else
 $B echo "$(date +%X) - Patching SafetyNET">>$L;
 fi;
 $B kill -9 "$($B pgrep com.google.android.gms.unstable)";
 $B sed 's/ORANGE/GREEN/i' /proc/cmdline|$B sed 's/YELLOW/GREEN/i'>/data/local/tmp/cmdline;
 $B chmod 644 /data/local/tmp/cmdline;
 $B mount -o bind /data/local/tmp/cmdline /proc/cmdline;
 fi;
 fi;
 $B sleep 1;
 $B killall bb.so;
 $B killall dd.so;
 $B rm -f /fde.ai/s/bb.so;
 $B rm -f /fde.ai/s/dd.so;
 
 if [ -n "$RUS" ];then
 $B echo "Всё прошло успешно.">>$L;
 else
 $B echo "ALL is GOOD.">>$L;
 fi;
 $B echo " ">>$L;
 input keyevent 224;
 $B echo "120">/sys/devices/virtual/timed_output/vibrator/enable;
 $B sleep 0.3;
 $B echo "120">/sys/devices/virtual/timed_output/vibrator/enable;
 
 if [ -n "$RUS" ];then
 am start -a android.intent.action.MAIN -e message "FDE.AI - Всё ОК" -n com.android.msg/.ShowToast;
 else 
 am start -a android.intent.action.MAIN -e message "FDE.AI - All is GOOD" -n com.android.msg/.ShowToast;
 fi;
 
 svc power stayon false;
 for x in $($B mount|$B grep ext4|$B cut -d " " -f3);do 
 $B mount -o remount,noatime,nodiratime,nobarrier,nodiscard,max_batch_time=30000,min_batch_time=10000,commit=21 "${x}";
 done;
 for gf in $($B mount|$B grep f2fs|$B cut -d " " -f3);do 
 $B mount -o remount,nobarrier "${gf}";
 done;
 exit;
