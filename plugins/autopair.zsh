#!/bin/zsh

AUTOPAIR_BETWEEN_WHITESPACE=
#AUTOPAIR_INHIBIT_INIT=
AUTOPAIR_PAIRS=('`' '`' "'" "'" '"' '"' '{' '}' '[' ']' '(' ')' ' ' ' ')
AUTOPAIR_LBOUNDS=(all '[.:/\!]')
AUTOPAIR_LBOUNDS+=(quotes '[]})a-zA-Z0-9]')
AUTOPAIR_LBOUNDS+=(spaces '[^{([]')
AUTOPAIR_LBOUNDS+=(braces '')
AUTOPAIR_LBOUNDS+=('`' '`')
AUTOPAIR_LBOUNDS+=('"' '"')
AUTOPAIR_LBOUNDS+=("'" "'")

AUTOPAIR_RBOUNDS=(all '[[{(<,.:?/%$!a-zA-Z0-9]')
AUTOPAIR_RBOUNDS+=(quotes '[a-zA-Z0-9]')
AUTOPAIR_RBOUNDS+=(spaces '[^]})]')
AUTOPAIR_RBOUNDS+=(braces '')

typeset -gA AUTOPAIR_PAIRS
AUTOPAIR_PAIRS+=("<" ">")

zplugin ice lucid \
    wait'3' \
    atinit"zpcompinit;zpcdreplay" 
zplugin load hlissner/zsh-autopair

# vim: ft=zsh tw=78 et ts=2 sts=2 sw=2 cc=80
