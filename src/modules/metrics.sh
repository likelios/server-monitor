#!/bin/bash

# System metrics collection module

get_system_metrics() {
    # CPU load
    if command -v uptime &> /dev/null; then
        load_data=$(uptime | awk -F'load average:' '{print $2}')
        load_1=$(echo "$load_data" | cut -d, -f1 | tr -d ' ' | sed 's/,/./g' | grep -o '[0-9.]*' || echo "0.00")
        load_5=$(echo "$load_data" | cut -d, -f2 | tr -d ' ' | sed 's/,/./g' | grep -o '[0-9.]*' || echo "0.00")
        load_15=$(echo "$load_data" | cut -d, -f3 | tr -d ' ' | sed 's/,/./g' | grep -o '[0-9.]*' || echo "0.00")
    else
        load_1="0.00"; load_5="0.00"; load_15="0.00"
    fi

    cpu_cores=$(nproc 2>/dev/null || echo "1")

    # Memory
    if command -v free &> /dev/null; then
        mem_total=$(free -m | awk '/^Mem:/{print $2}')
        mem_used=$(free -m | awk '/^Mem:/{print $3}')
        mem_free=$(free -m | awk '/^Mem:/{print $4}')
        mem_available=$(free -m | awk '/^Mem:/{print $7}')
        mem_percent=$((mem_used * 100 / mem_total))

        swap_total=$(free -m | awk '/^Swap:/{print $2}')
        swap_used=$(free -m | awk '/^Swap:/{print $3}')
        swap_percent=$([ "$swap_total" -gt 0 ] && echo $((swap_used * 100 / swap_total)) || echo "0")
    fi

    # Disk
    if command -v df &> /dev/null; then
        disk_used=$(df -h / | awk 'NR==2{print $3}' | sed 's/[^0-9.]*//g')
        disk_total=$(df -h / | awk 'NR==2{print $2}' | sed 's/[^0-9.]*//g')
        disk_percent=$(df -h / | awk 'NR==2{print $5}' | tr -d '%')
    fi

    # Uptime
    if [ -f /proc/uptime ]; then
        uptime_seconds=$(cat /proc/uptime | awk '{print $1}' | cut -d. -f1)
        uptime_days=$((uptime_seconds / 86400))
        uptime_hours=$(((uptime_seconds % 86400) / 3600))
        uptime_minutes=$(((uptime_seconds % 3600) / 60))
    fi

    process_count=$(ps aux | wc -l)
    tcp_connections=$(ss -t state established 2>/dev/null | wc -l)

    echo "load_1=${load_1:-0.00}|load_5=${load_5:-0.00}|load_15=${load_15:-0.00}|cpu_cores=${cpu_cores:-1}|mem_total=${mem_total:-0}|mem_used=${mem_used:-0}|mem_free=${mem_free:-0}|mem_available=${mem_available:-0}|mem_percent=${mem_percent:-0}|swap_total=${swap_total:-0}|swap_used=${swap_used:-0}|swap_percent=${swap_percent:-0}|disk_used=${disk_used:-0}|disk_total=${disk_total:-0}|disk_percent=${disk_percent:-0}|uptime_days=${uptime_days:-0}|uptime_hours=${uptime_hours:-0}|uptime_minutes=${uptime_minutes:-0}|process_count=${process_count:-0}|tcp_connections=${tcp_connections:-0}"
}