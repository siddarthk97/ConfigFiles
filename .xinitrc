#! /usr/bin/env bash
[[ -f ~/.Xmodmap ]] && xmodmap -e "clear Lock"
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap
exec i3
