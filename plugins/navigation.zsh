#!/bin/zsh

zplugin ice wait'0' 
zplugin load Tarrasch/zsh-bd

zplugin ice svn blockf wait'0' pick"autojump.zsh"
zplugin snippet https://github.com/wting/autojump/blob/master/bin
# vim: ft=zsh tw=78 et ts=2 sts=2 sw=2 cc=80
