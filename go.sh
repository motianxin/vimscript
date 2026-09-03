#!/bin/bash

# 历史文件路径
HIST_FILE="$HOME/go.his"

# 颜色定义数组（7种不同颜色）
COLORS=(
    "\033[1;31m"  # 红色
    "\033[1;32m"  # 绿色
    "\033[1;33m"  # 黄色
    "\033[1;34m"  # 蓝色
    "\033[1;35m"  # 紫色
    "\033[1;36m"  # 青色
    "\033[1;37m"  # 白色
)
RESET_COLOR="\033[0m"

# 确保历史文件存在
if [ ! -f "$HIST_FILE" ]; then
    touch "$HIST_FILE"
fi

# 函数：获取颜色代码
get_color() {
    local line_num=$1
    # 使用模运算循环颜色，行号从1开始，减1转换为0-based索引
    local color_index=$(( (line_num - 1) % ${#COLORS[@]} ))
    echo "${COLORS[$color_index]}"
}

# 函数：添加当前目录到历史文件
add_directory() {
    local current_dir=$(pwd)

    # 检查是否已存在于最后一行（避免重复添加）
    local last_line=$(tail -n 1 "$HIST_FILE" 2>/dev/null)
    if [ "$last_line" != "$current_dir" ]; then
        echo "$current_dir" >> "$HIST_FILE"
        echo -e "\033[1;32m✓ 已添加目录:\033[0m $current_dir"
        show_history_for_selection -s
    else
        echo -e "\033[1;33m⚠ 目录已在历史记录中:\033[0m $current_dir"
    fi
}

# 函数：计算字符串显示宽度（考虑中文字符）
display_length() {
    local str="$1"
    # 移除颜色代码
    local clean_str=$(echo -e "$str" | sed 's/\x1b\[[0-9;]*m//g')

    # 计算实际显示宽度（中文字符算2个宽度）
    local length=0
    for (( i=0; i<${#clean_str}; i++ )); do
        local char="${clean_str:$i:1}"
        # 检查是否为中文字符（Unicode范围）
        if [[ $char =~ [[:punct:]] || $char =~ [[:alnum:]] || $char =~ [[:space:]] ]]; then
            ((length++))
        else
            ((length+=2))
        fi
    done
    echo $length
}

# 函数：显示历史记录（表格形式）
list_history() {
    if [ ! -s "$HIST_FILE" ]; then
        echo -e "\033[1;33m历史记录为空\033[0m"
        return 1
    fi

    local total_lines=$(wc -l < "$HIST_FILE")

    echo -e "\033[1;36m历史记录 ($HIST_FILE) [共 ${total_lines} 项]:\033[0m"
    echo -e "\033[1;34m┌────────────────────────────────────────────────────────────────────────────────┐\033[0m"

    # 读取所有目录到数组
    mapfile -t directories < "$HIST_FILE"

    # 计算最大目录显示长度
    local max_dir_length=0
    local dir_index=0
    for dir in "${directories[@]}"; do
        ((dir_index++))
        local color=$(get_color $dir_index)
        local colored_dir="${color}${dir}\033[0m"
        local dir_length=$(display_length "$colored_dir")
        if [ $dir_length -gt $max_dir_length ]; then
            max_dir_length=$dir_length
        fi
    done

    # 计算最大行号长度
    local max_num_length=${#total_lines}

    # 计算表格总宽度（目录宽度 + 行号宽度 + 边框等）
    local table_width=$((max_dir_length + max_num_length + 10))
    if [ $table_width -lt 120 ]; then
        table_width=120
    fi

    # 显示每一行
    dir_index=0
    for dir in "${directories[@]}"; do
        ((dir_index++))
        local color=$(get_color $dir_index)
        local formatted_num=$(printf "%${max_num_length}d" $dir_index)

        # 创建带颜色的目录字符串
        local colored_dir="${color}${dir}\033[0m"
        local dir_display_length=$(display_length "$colored_dir")

        # 计算需要的空格填充
        local padding=$((max_dir_length - dir_display_length))
        if [ $padding -lt 0 ]; then
            padding=0
        fi

        # 构建表格行
        echo -en "\033[0;90m│\033[0m "
        echo -en "$colored_dir"
        printf "%${padding}s"
        echo -en " \033[0;90m│\033[0m "
        echo -e "${color}${formatted_num}\033[0m \033[0;90m│\033[0m"

        # 如果不是最后一行，添加分隔线
        if [ $dir_index -lt $total_lines ]; then
            echo -e "\033[0;90m├────────────────────────────────────────────────────────────────────────────────┤\033[0m"
        fi
    done

    echo -e "\033[1;34m└────────────────────────────────────────────────────────────────────────────────┘\033[0m"

    # 显示颜色说明
    echo -e "\033[0;90m颜色说明:\033[0m"
    echo -n "  "
    for ((i=0; i<${#COLORS[@]}; i++)); do
        echo -en "${COLORS[i]}● ${RESET_COLOR}"
        # case $i in
            # 0) echo -n "红 ";;
            # 1) echo -n "绿 ";;
            # 2) echo -n "黄 ";;
            # 3) echo -n "蓝 ";;
            # 4) echo -n "紫 ";;
            # 5) echo -n "青 ";;
            # 6) echo -n "白 ";;
        # esac
    done
    echo -e "\033[0;90m（颜色循环使用）\033[0m"
}

# 函数：显示简化版历史记录（用于选择时）
show_history_for_selection() {
    if [ ! -s "$HIST_FILE" ]; then
        echo -e "\033[1;33m历史记录为空\033[0m"
        return 1
    fi

    local total_lines=$(wc -l < "$HIST_FILE")
    case "$1" in
        "-s"|"--simple")
            echo -e "\033[1;36m历史记录 ($HIST_FILE) [共 ${total_lines} 项]:\033[0m"
            ;;
        "")
            echo -e "\033[1;36m请选择目录 [1-${total_lines}]:\033[0m"
            ;;
    esac


    # 读取所有目录到数组
    mapfile -t directories < "$HIST_FILE"

    # 计算最大目录长度（不带颜色）
    local max_dir_length=0
    for dir in "${directories[@]}"; do
        local dir_length=${#dir}
        if [ $dir_length -gt 160 ]; then
            dir_length=60  # 限制最大显示长度
        fi
        if [ $dir_length -gt $max_dir_length ]; then
            max_dir_length=$dir_length
        fi
    done

    # 计算最大行号长度
    local max_num_length=${#total_lines}

    # 显示每一行
    echo -en "\033[0;90m┌─"
    for i in $(seq 1 $((max_dir_length + max_num_length + 7))); do
        echo -en "─"
    done
    echo -e "─┐\033[0m"

    for ((i=0; i<${#directories[@]}; i++)); do
        local dir="${directories[$i]}"
        local line_num=$((i + 1))
        local color=$(get_color $line_num)
        local formatted_num=$(printf "%${max_num_length}d" $line_num)

        # 截断过长的目录名
        local display_dir="$dir"
        if [ ${#display_dir} -gt 160 ]; then
            display_dir="${display_dir:0:157}..."
        fi

        # 计算填充空格
        local padding=$((max_dir_length - ${#display_dir}))

        echo -en "\033[0;90m│\033[0m "
        echo -en "${color}${display_dir}\033[0m"
        printf "%${padding}s"
        echo -en " \033[0;90m│\033[0m "
        echo -e "${color}${formatted_num}\033[0m \033[0;90m│\033[0m"
    done

    echo -en "\033[0;90m└─"
    for i in $(seq 1 $((max_dir_length + max_num_length + 7))); do
        echo -en "─"
    done
    echo -e "─┘\033[0m"
}

# 函数：根据行号删除目录记录
delete_by_line() {
    if [ ! -s "$HIST_FILE" ]; then
        echo -e "\033[1;33m历史记录为空，无需删除\033[0m"
        return 1
    fi

    # 显示当前历史记录
    list_history

    # 获取总行数
    local total_lines=$(wc -l < "$HIST_FILE")

    # 询问用户要删除的行号
    read -p "$(echo -e '\033[1;33m请输入要删除的行号\033[0m (1-${total_lines}, 或 \033[1;31mq\033[0m 退出): ')" line_num

    # 检查是否要退出
    if [[ "$line_num" == "q" || "$line_num" == "Q" ]]; then
        echo -e "\033[1;34m操作取消\033[0m"
        return 0
    fi

    # 检查输入是否为数字
    if ! [[ "$line_num" =~ ^[0-9]+$ ]]; then
        echo -e "\033[1;31m✗ 错误: 请输入有效的数字\033[0m"
        return 1
    fi

    # 检查行号是否在有效范围内
    if [ "$line_num" -lt 1 ] || [ "$line_num" -gt "$total_lines" ]; then
        echo -e "\033[1;31m✗ 错误: 行号超出范围 (1-${total_lines})\033[0m"
        return 1
    fi

    # 获取要删除的目录路径（用于显示信息）
    local target_dir=$(sed -n "${line_num}p" "$HIST_FILE")
    local color=$(get_color $line_num)

    # 确认删除
    echo -e "\n\033[1;33m⚠ 确定要删除以下目录吗？\033[0m"
    echo -e "${color}${target_dir}\033[0m \033[1;37m[${line_num}]\033[0m"
    read -p "$(echo -e '请输入 \033[1;32my\033[0m 确认删除 或 \033[1;31mN\033[0m 取消: ')" confirm

    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        # 使用临时文件删除指定行
        local temp_file=$(mktemp)

        # 删除指定行并保存到临时文件
        sed "${line_num}d" "$HIST_FILE" > "$temp_file"

        # 检查删除后文件是否为空
        if [ ! -s "$temp_file" ]; then
            echo -e "\033[1;33m⚠ 警告: 删除后将导致历史记录为空\033[0m"
            read -p "$(echo -e '是否继续？(请输入 \033[1;32my\033[0m 继续 或 \033[1;31mN\033[0m 取消): ')" empty_confirm
            if [[ "$empty_confirm" != "y" && "$empty_confirm" != "Y" ]]; then
                rm "$temp_file"
                echo -e "\033[1;34m删除操作已取消\033[0m"
                return 0
            fi
        fi

        # 用临时文件替换原文件
        mv "$temp_file" "$HIST_FILE"
        echo -e "\033[1;32m✓ 已成功删除第 ${line_num} 行\033[0m"

        # 显示删除后的历史记录
        if [ -s "$HIST_FILE" ]; then
            echo -e "\033[1;36m删除后的历史记录:\033[0m"
            list_history
        else
            echo -e "\033[1;33m历史记录现在为空\033[0m"
        fi
    else
        echo -e "\033{1;34m删除操作已取消\033[0m"
    fi
}

# 函数：根据行号跳转目录
jump_to_directory() {
    if [ ! -s "$HIST_FILE" ]; then
        echo -e "\033[1;33m历史记录为空，请先使用 -a 参数添加目录\033[0m"
        return 1
    fi

    # 显示简化版的历史记录
    show_history_for_selection
    # list_history
    # 获取总行数
    local total_lines=$(wc -l < "$HIST_FILE")

    while true; do
        read -p "$(echo -e '\033[1;36m请输入要跳转的行号\033[0m (1-${total_lines}, 或 \033[1;31mq\033[0m 退出): ')" line_num

        # 检查是否要退出
        if [[ "$line_num" == "q" || "$line_num" == "Q" ]]; then
            echo -e "\033[1;34m退出\033[0m"
            return 0
        fi

        # 检查输入是否为数字
        if ! [[ "$line_num" =~ ^[0-9]+$ ]]; then
            echo -e "\033[1;31m✗ 错误: 请输入有效的数字\033[0m"
            continue
        fi

        # 检查行号是否在有效范围内
        if [ "$line_num" -lt 1 ] || [ "$line_num" -gt "$total_lines" ]; then
            echo -e "\033[1;31m✗ 错误: 行号超出范围 (1-${total_lines})\033[0m"
            continue
        fi

        # 获取对应行的目录
        local target_dir=$(sed -n "${line_num}p" "$HIST_FILE")

        # 检查目录是否存在
        if [ -d "$target_dir" ]; then
            local color=$(get_color $line_num)
            echo -e "\n${color}正在跳转到:\033[0m ${target_dir}"
            cd "$target_dir" || {
                echo -e "\033[1;31m✗ 错误: 无法跳转到目录\033[0m"
                return 1
            }
            echo -e "\033[1;32m✓ 当前目录:\033[0m $(pwd)"
            break
        else
            echo -e "\033[1;33m⚠ 警告: 目录不存在:\033[0m $target_dir"
            read -p "$(echo -e '是否删除此记录？(请输入 \033[1;32my\033[0m 删除 或 \033[1;31mN\033[0m 跳过): ')" delete_choice
            if [[ "$delete_choice" == "y" || "$delete_choice" == "Y" ]]; then
                # 删除该行
                sed -i "${line_num}d" "$HIST_FILE"
                echo -e "\033[1;32m✓ 已删除第 ${line_num} 行记录\033[0m"
                show_history_for_selection -s
            fi
        fi
    done
}

# 主函数
main() {
    case "$1" in
        "-a"|"--add")
            add_directory
            ;;
        "-l"|"--list")
            list_history
            ;;
        "-r"|"--remove")
            delete_by_line
            ;;
        "-s"|"--simple")
            show_history_for_selection -s
            ;;
        "-h"|"--help")
            echo -e "\033[1;36m使用说明:\033[0m"
            echo -e "  \033[1;37m$0\033[0m          显示历史记录并选择跳转"
            echo -e "  \033{1;37m$0 -a\033[0m       添加当前目录到历史记录"
            echo -e "  \033[1;37m$0 -l\033[0m       显示历史记录（表格形式，带颜色）"
            echo -e "  \033[1;37m$0 -r\033[0m       删除历史记录中的目录"
            echo -e "  \033[1;37m$0 -s\033[0m       显示简化版历史记录"
            echo -e "  \033[1;37m$0 -h\033[0m       显示帮助信息"
            echo -e "\033[1;36m历史文件:\033[0m $HIST_FILE"
            echo -e "\033[1;36m颜色循环:\033[0m 7种颜色循环使用，超过7行颜色会重复"
            ;;
        "")
            jump_to_directory
            ;;
        *)
            echo -e "\033[1;31m✗ 错误: 未知参数 '$1'\033[0m"
            echo -e "使用 '\033[1;37m$0 -h\033[0m' 查看帮助"
            ;;
    esac
}

# 运行主函数
main "$1"
