#!/bin/bash
# 獲取記憶體總量和已使用的記憶體量
mem_info=$(free | grep Mem)
total_mem=$(echo $mem_info | awk '{print $2}')
used_mem=$(echo $mem_info | awk '{print $3}')

# 計算記憶體使用率
mem_usage_f=$(echo "scale=3; $used_mem / $total_mem * 100" | bc)
mem_usage=$(echo "$mem_usage_f" | awk '{print int($1)}')

# 設置顏色
if (( $(echo "$mem_usage > 90" | bc -l) )); then
    color="red"   # 超過 90% 記憶體使用，顯示紅色
elif (( $(echo "$mem_usage > 50" | bc -l) )); then
    color="yellow" # 超過 50% 記憶體使用，顯示黃色
else
    color="green"  # 否則顯示綠色
fi

# 設定顏色
if [ "$mem_usage" -gt 90 ]; then
    color="red"  # 紅色
elif [ "$mem_usage" -gt 50 ]; then
    color="yellow"  # 黃色
else
    color="green"  # 綠色
fi

# 輸出結果：適應 tmux 顯示
echo -e "MEM:#[fg=$color]$(printf '%3d' "$mem_usage")%#[default]"
