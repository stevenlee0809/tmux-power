#!/bin/bash

# 取得 CPU 核心數
cpu_cores=$(nproc)

# 用 UID 和 %cpu 計算每個使用者的 CPU 使用率總和
top_user_data=$(ps -eo uid,%cpu --no-headers | awk '{cpu[$1]+=$2} END {for (uid in cpu) if (cpu[uid] > 0) print cpu[uid], uid}' | sort -rn | head -n 1)
top_cpu=$(echo "$top_user_data" | awk '{print $1}')
top_uid=$(echo "$top_user_data" | awk '{print $2}')

# 將 UID 轉成完整使用者名稱
top_user=$(id -un "$top_uid" 2>/dev/null || echo "unknown")

# 計算平均 CPU 使用率
avg_cpu=$(echo "$top_cpu / $cpu_cores" | bc -l | awk '{if ($0 > 100) printf "100"; else printf "%.1f", $0}')

if [ "$avg_cpu" -gt 90 ]; then
    color="red"  # 紅色
elif [ "$avg_cpu" -gt 50 ]; then
    color="yellow"  # 黃色
else
    color="green"  # 綠色
fi

# 輸出結果
if [ -n "$top_user" ] && [ "$top_user" != "unknown" ]; then
    dynamic_part="$top_user ($avg_cpu%)"
    echo -e "TOP:#[fg=$color]$(printf '%21.21s' "$dynamic_part")#[default]"
else
    # 右對齊 "N/A"
    echo -e "TOP:#[fg=$color]$(printf '%21s' "N/A")#[default]"
fi
