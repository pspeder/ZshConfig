#!/bin/zsh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=1
#ZSH_AUTOSUGGEST_MANUAL_REBIND=1
#To re-bind widgets, run _zsh_autosuggest_bind_widgets.

bindkey '^ ' autosuggest-accept

#zplugin ice lucid \
#    wait'1' \
#    atload'_zsh_autosuggest_start'
#zplugin load zsh-users/zsh-autosuggestions
zplugin light zsh-users/zsh-autosuggestions

# vim: ft=zsh tw=78 et ts=2 sts=2 sw=2 cc=80
