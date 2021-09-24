#!/bin/zsh

export KEYTIMEOUT=1

bindkey '^P' up-history
bindkey '^N' down-history

bindkey '^[[2~' overwrite-mode
bindkey '^[[3~' delete-char

bindkey "$terminfo[khome]" beginning-of-line
bindkey "$terminfo[kend]" end-of-line
if [ "$TERM" == "screen-256*" ]
then
  bindkey '^[[1~' beginning-of-line
  bindkey '^[[4~' end-of-line
else
  bindkey '^[[7~' beginning-of-line
  bindkey '^[[8~' end-of-line
fi

# vim: set tw=78 ts=2 sts=2 sw=2 cc=80
