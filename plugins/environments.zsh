#!/bin/zsh

AUTOENV_FILE_ENTER=.autoenv.zsh
AUTOENV_HANDLE_LEAVE=1
AUTOENV_FILE_LEAVE=.autoenv_leave.zsh
AUTOENV_LOOK_UPWARDS=1
AUTOENV_DISABLED=0
AUTOENV_DEBUG=0
AUTOENV_EDITOR="$EDITOR"


# Add hook for direnv
zplugin ice lucid \
    from"gh-r" \
    as"program" \
    mv"direnv* -> direnv" \
    atclone'./direnv hook zsh > zhook.zsh' \
    atpull'%atclone' \
    pick"direnv"
zplugin load direnv/direnv


zplugin ice lucid wait'1' 
zplugin load "Tarrasch/zsh-autoenv"

# vim: ft=zsh tw=78 et ts=2 sts=2 sw=2 cc=80
