for CPU in /sys/devices/system/cpu/cpu[0-9]*; do
        [[ -e $CPU/online ]] && echo "1" > $CPU/online
done
