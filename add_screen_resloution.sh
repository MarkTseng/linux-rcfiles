#!/bin/bash
# screen resolution link : https://zh.wikipedia.org/zh-tw/%E6%98%BE%E7%A4%BA%E5%88%86%E8%BE%A8%E7%8E%87%E5%88%97%E8%A1%A8

cvt 1680 1050 60
# Modeline "1600x900_60.00"  118.25  1600 1696 1856 2112  900 903 908 934 -hsync +vsync
xrandr --newmode "1680x1050_60.00"  146.25  1680 1784 1960 2240  1050 1053 1059 1089 -hsync +vsync

# xrandr  
# Screen 0: minimum 320 x 200, current 2560 x 1600, maximum 16384 x 16384
# eDP-1 connected primary 2560x1600+0+0 (normal left inverted right x axis y axis) 216mm x 135mm
#   2560x1600     60.00*+
xrandr --addmode eDP-1 "1680x1050_60.00"
xrandr --output eDP-1 --mode "1680x1050_60.00"

# ADD xrandr newmode & addmode in Xsetup
# sudo vi /usr/share/sddm/scripts/Xsetup

