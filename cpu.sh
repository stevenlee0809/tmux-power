#!/bin/bash

# 讀取 CPU 時間
read cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat

# 計算總時間和非閒置時間
total=$((user + nice + system + idle + iowait + irq + softirq + steal))
busy=$((total - idle))

# 等待 0.5 秒後再取一次數據
sleep 0.5

# 讀取 CPU 時間（第二次）
read cpu user2 nice2 system2 idle2 iowait2 irq2 softirq2 steal2 guest2 guest_nice2 < /proc/stat

# 計算新的總時間和非閒置時間
total2=$((user2 + nice2 + system2 + idle2 + iowait2 + irq2 + softirq2 + steal2))
busy2=$((total2 - idle2))

# 計算 CPU 使用率（無小數）
cpu_usage=$(( (busy2 - busy) * 100 / (total2 - total) ))

# 設定顏色
if [ "$cpu_usage" -gt 90 ]; then
    color="red"  # 紅色
elif [ "$cpu_usage" -gt 50 ]; then
    color="yellow"  # 黃色
else
    color="green"  # 綠色
fi

# 輸出結果：適應 tmux 顯示
echo -e "CPU:#[fg=$color]$(printf '%3d' "$cpu_usage")%#[default]"
