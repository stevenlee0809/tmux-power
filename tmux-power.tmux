#!/usr/bin/env bash
#===============================================================================
#   Author: Wenxuan
#    Email: wenxuangm@gmail.com
#  Created: 2018-04-05 17:37
#===============================================================================

# $1: option
# $2: default value
tmux_get() {
    local value="$(tmux show -gqv "$1")"
    [ -n "$value" ] && echo "$value" || echo "$2"
}

# $1: option
# $2: value
tmux_set() {
    tmux set-option -gq "$1" "$2"
}

# Options
right_arrow_icon=$(tmux_get '@tmux_power_right_arrow_icon' '')
left_arrow_icon=$(tmux_get '@tmux_power_left_arrow_icon' '')
icon_sep=$(tmux_get '@tmux_power_left_arrow_icon' '█')
upload_speed_icon=$(tmux_get '@tmux_power_upload_speed_icon' '')
download_speed_icon=$(tmux_get '@tmux_power_download_speed_icon' '')
session_icon="$(tmux_get '@tmux_power_session_icon' '')"
# user_icon="$(tmux_get '@tmux_power_user_icon' '')"
user_icon="$(tmux_get '@tmux_power_user_icon' '')"
# user_icon="$(tmux_get '@tmux_power_user_icon' '🎃')"
time_icon="$(tmux_get '@tmux_power_time_icon' '')"
date_icon="$(tmux_get '@tmux_power_date_icon' '')"
# cpu_icon="$(tmux_get '@tmux_power_cpu_icon' '')"
cpu_icon="$(tmux_get '@tmux_power_cpu_icon' '')"
mem_icon="$(tmux_get '@tmux_power_mem_icon' '')"
thermal_icon="$(tmux_get '@tmux_power_thermal_icon' '')"
show_upload_speed="$(tmux_get @tmux_power_show_upload_speed false)"
show_download_speed="$(tmux_get @tmux_power_show_download_speed false)"
show_web_reachable="$(tmux_get @tmux_power_show_web_reachable false)"
prefix_highlight_pos=$(tmux_get @tmux_power_prefix_highlight_pos)
time_format=$(tmux_get @tmux_power_time_format '%T')
date_format=$(tmux_get @tmux_power_date_format '%F')

# --> Catppuccin (Mocha)
thm_bg="#1e1e2e"
thm_fg="#cdd6f4"
thm_cyan="#89dceb"
thm_black="#181825"
thm_gray="#313244"
thm_magenta="#cba6f7"
thm_pink="#f5c2e7"
thm_red="#f38ba8"
thm_green="#a6e3a1"
thm_yellow="#f9e2af"
thm_blue="#89b4fa"
thm_orange="#fab387"
thm_black4="#585b70"

# short for Theme-Colour
TC=$(tmux_get '@tmux_power_theme' 'forest')
case $TC in
    'gold' )
        TC='#ffb86c'
        ;;
    'redwine' )
        TC='#b34a47'
        ;;
    'moon' )
        TC='#00abab'
        ;;
    'forest' )
        TC='#228b22'
        ;;
    'violet' )
        TC='#9370db'
        ;;
    'snow' )
        TC='#fffafa'
        ;;
    'coral' )
        TC='#ff7f50'
        ;;
    'orange' )
        TC=$thm_red
        ;;
    'sky' )
        TC='#87ceeb'
        ;;
    'default' ) # Useful when your term changes colour dynamically (e.g. pywal)
        TC='colour3'
        ;;
esac

# TC=$thm_green

G01=#080808 #232
G02=#121212 #233
G03=#1c1c1c #234
G04=#262626 #235
G05=#303030 #236
# G05=#ed8796 #236
G06=#3a3a3a #237
G07=#444444 #238
G08=#4e4e4e #239
G09=#585858 #240
G10=#626262 #241
G11=#6c6c6c #242
G12=#767676 #243

FG="$G10"
BG="$thm_bg"

# Status options
tmux_set status-interval 1
tmux_set status on

# Basic status bar colors
tmux_set status-fg "$FG"
tmux_set status-bg "$BG"
tmux_set status-attr none

# tmux-prefix-highlight
tmux_set @prefix_highlight_fg "$BG"
tmux_set @prefix_highlight_bg "$FG"
tmux_set @prefix_highlight_show_copy_mode 'on'
tmux_set @prefix_highlight_copy_mode_attr "fg=$TC,bg=$BG,bold"
tmux_set @prefix_highlight_output_prefix "#[fg=$TC]#[bg=$BG]$left_arrow_icon#[bg=$TC]#[fg=$BG]"
tmux_set @prefix_highlight_output_suffix "#[fg=$TC]#[bg=$BG]$right_arrow_icon"

#     
# Left side of status bar
tmux_set status-left-bg "$G04"
tmux_set status-left-fg "$G12"
tmux_set status-left-length 150
user=$(whoami)
# LS="#[fg=$thm_black,bg=$TC,bold] $user_icon $user@#h#[fg=$TC,bg=$thm_cyan,nobold]$right_arrow_icon#[fg=$thm_black,bg=$thm_cyan] $session_icon #S "
# LS="#[fg=$thm_black,bg=$TC,bold] $user_icon $user@#h #[fg=$TC,bg=$thm_cyan,nobold]$right_arrow_icon#[fg=$thm_black,bg=$thm_cyan] $session_icon #[bold]#S "
# LS="#[fg=$thm_black,bg=$TC,bold] $user_icon $user@#h#[fg=$TC,bg=$thm_bg,nobold]$right_arrow_icon  #[fg=$thm_bg,bg=$thm_cyan]$right_arrow_icon#[fg=$thm_black,bg=$thm_cyan] $session_icon #S"
# LS="#[fg=$thm_black,bg=$TC,bold] $user_icon #[fg=$TC,bg=$thm_bg]$right_arrow_icon #[fg=$thm_fg,bg=$thm_bg]$user@#h #[fg=$TC,bg=$thm_bg]$right_arrow_icon#[fg=$thm_cyan,bg=$thm_cyan,nobold]$right_arrow_icon#[fg=$thm_black,bg=$thm_cyan]$session_icon #S "
# LS="#[fg=$thm_black,bg=$TC,bold] $user_icon $user@#h #[fg=$TC,bg=$thm_cyan,nobold]$right_arrow_icon#[fg=$thm_black,bg=$thm_cyan] "
LS="#[fg=$thm_black,bg=$TC,bold] $user_icon $user@#h #[fg=$TC,bg=$thm_gray,nobold]$right_arrow_icon#[fg=$thm_fg,bg=$thm_gray] "
LS="$LS$session_icon #S "
LS="$LS#[fg=$thm_gray,bg=$BG]$right_arrow_icon"
if [[ $prefix_highlight_pos == 'L' || $prefix_highlight_pos == 'LR' ]]; then
    LS="$LS#{prefix_highlight}"
fi
tmux_set status-left "$LS"

# Right side of status bar
# tmux_set status-right-bg "$BG"
# tmux_set status-right-fg "G12"
tmux_set status-right-length 150
RS="#[fg=$thm_blue,bg=$thm_bg]$left_arrow_icon#[fg=$thm_black,bg=$thm_blue]$date_icon #[fg=$thm_fg,bg=$thm_gray] $date_format#[fg=$thm_gray,bg=$thm_bg]$right_arrow_icon"
RS="#[fg=$thm_green]$left_arrow_icon#[fg=$thm_black,bg=$thm_green]$time_icon #[fg=$thm_fg,bg=$thm_gray] $time_format#[fg=$thm_gray,bg=$thm_bg]$right_arrow_icon $RS"
RS=" #[fg=$thm_pink]$left_arrow_icon#[fg=$thm_bg,bg=$thm_pink]$mem_icon #[fg=$thm_fg,bg=$thm_gray] #{sysstat_mem}#[fg=$thm_gray,bg=$thm_bg]$right_arrow_icon $RS"
RS=" #[fg=$thm_yellow]$left_arrow_icon#[fg=$thm_bg,bg=$thm_yellow]$cpu_icon #[fg=$thm_fg,bg=$thm_gray] #{sysstat_cpu}#[fg=$thm_gray,bg=$thm_bg]$right_arrow_icon$RS"

if [[ $prefix_highlight_pos == 'R' || $prefix_highlight_pos == 'LR' ]]; then
    RS="#{prefix_highlight}$RS"
fi

tmux_set status-right "$RS"

# Window status
tmux_set window-status-format " [#I] #W#F "
# tmux_set window-status-current-format "#[fg=$thm_gray,bg=$BG]$left_arrow_icon#[fg=$TC,bg=$thm_gray,bold] [#I] #W#F #[fg=$thm_gray,bg=$BG,nobold]$right_arrow_icon"
tmux_set window-status-current-format "#[fg=$TC]$left_arrow_icon#[fg=$thm_bg,bg=$TC,bold]#I #[fg=$TC,bg=$thm_gray] #W#F #[fg=$thm_gray,bg=$BG,nobold]$right_arrow_icon"

# Window separator
tmux_set window-status-separator ""

# Window status alignment
tmux_set status-justify centre

# Current window status
tmux_set window-status-current-status "fg=$TC,bg=$BG"

# Pane border
tmux_set pane-border-style "fg=$G07,bg=default"

# Active pane border
#tmux_set pane-active-border-style "fg=$TC,bg=$BG"
tmux_set pane-active-border-style "fg=$TC"

# Pane number indicator
tmux_set display-panes-colour "$G07"
tmux_set display-panes-active-colour "$TC"

# Clock mode
tmux_set clock-mode-colour "$TC"
tmux_set clock-mode-style 24

# Message
tmux_set message-style "fg=$TC,bg=$BG"

# Command message
tmux_set message-command-style "fg=$TC,bg=$BG"

# Copy mode highlight
tmux_set mode-style "bg=$TC,fg=$FG"
