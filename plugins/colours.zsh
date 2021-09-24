#!/bin/zsh

## Associative array containing easy access to colours and their light_
## variant.
#zplugin light zpm-zsh/colors
#
## Set appropriate dircolors
#zplugin ice lucid \
#  wait"2" \
#  atclone"dircolors -b $COLOUR_CONFIG_FILE > $COLOUR_CACHE_FILE" \
#  atpull'%atclone'
#zplugin load trapd00r/LS_COLORS
#
## Try harder to source appropriate termcap/terminfo
#zplugin light "chrissicool/zsh-256color"
#
## Add --color=auto
#zplugin light zpm-zsh/colorize

# vim: ft=zsh tw=78 et ts=2 sts=2 sw=2 cc=80
