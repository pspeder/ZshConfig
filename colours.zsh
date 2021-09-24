#!/bin/zsh

autoload -U colors && colors

#export ZSH_HIGHLIGHT_HIGHLIGHTERS+=brackets

COLOUR_CONFIG_FILE="$HOME/.dircolors"
COLOUR_CACHE_FILE="$ZDOTDIR/.colours_cache"

() {
  [[ -s "$COLOUR_CACHE_FILE" ]] && { eval $(cat "$COLOUR_CACHE_FILE"); return; }
  (( $+commands[dircolors] )) || return
  [[ -s "$COLOUR_CONFIG_FILE" ]] || unset $COLOUR_CONFIG_FILE # NOTE this seems weird

  local colours=$(dircolors -b "$COLOUR_CONFIG_FILE")
  echo "$colours" > "$COLOUR_CACHE_FILE"
  eval $(cat "$colours")
}


# Zsh completions to use the same colors as ls
# TODO maybe set with completions instead?
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# vim: ft=zsh et tw=78 ts=2 sts=2 sw=2 cc=80
