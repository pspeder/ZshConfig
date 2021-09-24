#!/bin/env zsh

#zplugin ice lucid \
#    from"gh-r" \
#    as"program" \
#    atclone"./configure --prefix $ZPFX && make && make install" \
#    atpull"%atclone"
#zplugin load dvorka/hstr

#shopt -s histappend

export HISTFILESIZE=20000
export HISTSIZE=2048
export HISTCONTROL=ignorespace
export HISTFILE=$HOME/.cache/shell_history

# Ensure flushing of history
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"

export HSTR_CONFIG=hicolor,raw-history-view,keywords-matching,case-sensitive,warning
#    # Make hstr colorful
#    hicolor,\
#    #monochromatic,\
#    #
#    # Do not display 
#    raw-history-view,\
#    #favorites-view,\
#    #
#    # Search
#    keywords-matching,\
#    #substring-matching,\
#    #regexp-matching,\
#    #
#    case-sensitive,\
#    #duplicates,\
#    #
#    #static-favorites,\
#    #skip-favorites-comments,\
#    #
#    # Blacklist certain commands from ever entering the history
#    # (defined in ~/.hstr_blacklist
#    #blacklist,\
#    #
#    # Confirm the deletion of entries
#    #no-confirm,\
#    #
#    #verbose-kill,\
#    warning,\
#    #debug
 
# Remove certain patterns
export HISTORY_EXCLUDE_PATTERN="^ykchalresp|$HISTORY_EXCLUDE_PATTERN"
zplugin ice lucid wait'3'
zplugin load jgogstad/passwordless-history

