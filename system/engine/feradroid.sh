#!/system/bin/sh
### FeraDroid Engine v0.19 | By FeraVolt. 2015 ###

B=/system/engine/bin/busybox
SH=/system/engine/bin/sh

$B mount -o remount,rw /system
$B mount -o remount,rw /data
$B chmod 644 /system/build.prop
$B chmod -R 777 /system/engine/gears/*
$B chmod 777 /system/etc/sysctl.conf
$SH /system/engine/gears/001abc.sh
$SH /system/engine/gears/002def.sh