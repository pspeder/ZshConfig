#!/bin/zsh
#
# The run configuration all interactive ZSH instances will operate in
#

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# TODO find out why it complains about _unknown not being found.
#      Workaround for now, create empty
#      $ZSH_INSTANCE[COMPLETIONS_DIR]/_unknown

# Options {{{
# ===========

setopt AUTO_CD              # CD if not cmd and also a directory name
# Globbing
setopt EXTENDED_GLOB        # ZSH's extended globbing
setopt NOTIFY
setopt NO_COMPLETE_ALIASES
#setopt nohashdir        # Automatic update hash after updates
setopt PROMPT_SUBST

setopt BEEP
unsetopt LIST_BEEP
unsetopt nomatch

# If set terminals will quit after TMOUT seconds
unset TMOUT

# ===============
# End Options }}}

# Enable some zsh modules
zmodload zsh/terminfo \
         zsh/mathfunc \
         zsh/mapfile  \
         zsh/complist

() { # Cache and load functions needed for RC-scripting {{{
  local rc_funcs=(
    # Prepend with ':/' to just autoload function (not compile it)
    :/compinit
    ./get_title
    ./pid_to_cmd
    ./alias_if_present
    ./alias_sudo
    ./read_file
    ./paths/{empty_dir,path_contains_symlinks,path_like,rel_to_abs_path}
  )
  #autoload -URz compinit

  autoload_and_compile $ZSH_INSTANCE[RC_FUNCS_FILE] $rc_funcs > /dev/null 2>&1

  ZSH_INSTANCE[RC_FUNCS]="${(j.:.)rc_funcs}"
} #}}}

# Setup Plugin Manager {{{
# ========================
typeset -A ZINIT
ZINIT[HOME_DIR]=$ZSH_INSTANCE[CACHE_DIR]/zinit

ZINIT[BIN_DIR]=$ZINIT[HOME_DIR]/bin
ZINIT[SOURCE]=$ZINIT[BIN_DIR]/zinit.zsh

ZINIT[COMPINIT_OPTS]+=-C
ZINIT[ZCOMPDUMP_PATH]=$ZSH_INSTANCE[CACHE_DIR]/zcompdump

ZINIT[COMPLETIONS_DIR]=$ZINIT[HOME_DIR]/completions
ZINIT[SNIPPETS_DIR]=$ZINIT[HOME_DIR]/snippets
ZINIT[PLUGINS_DIR]=$ZINIT[HOME_DIR]/plugins
ZPFX=$ZINIT[HOME_DIR]/polaris

# Get plugin manager if not present
if [[ ! -f "$ZINIT[SOURCE]" ]]; then
  git clone https://github.com/zdharma/zinit $ZINIT[BIN_DIR]
# TODO
#else 
#  run_async=+(pull_git_repo "$ZINIT[BIN_DIR]")
fi

[[ -f "$ZINIT[SOURCE].zwc" ]] || zcompile -UMz $ZINIT[SOURCE]

# Load zinit (should choose compiled version: 
# https://unix.stackexchange.com/questions/454126)
source $ZINIT[SOURCE]

# Load completions for zinit 
autoload -Uz _zinit
(( $+_comps )) && _comps[zinit]=_zinit

# ============================
# End Setup Plugin Manager }}}

# Scripting Utilities {{{
# =======================

# Load this always and immediately
zinit light willghatch/zsh-hooks

# Load this always and immediately
zinit ice pick'async.zsh'
zinit light mafredri/zsh-async
async_start_worker main -u -n
async_worker_eval  main 'mkdir -p $ZSH_INSTANCE[TMP_DIR]/async/main \
                         && cd $ZSH_INSTANCE[TMP_DIR]/async/main'
# p () { print $@ }
# async_register_callback main p

# Functional programming capabilities
zinit light Tarrasch/zsh-functional

# Mostly curiosum
#zinit light molovo/crash

# ===========================
# End Scripting Utilities }}}

PERIODS=1
PERIOD=30

update_ext_ip () {
  # Every PERIOD*50 seconds
  (( PERIODS % 50 != 0 )) && return
  async_job main 'curl http://ipecho.net/plain'
}

update_ext_ip_cb () {
  # TODO parse stdout to find HTTP status code?
  # TODO log errors
  (( $2 )) && return 
  ZSH_INSTANCE[IP]=$3
}

update_periods () {
  # TODO Hopefully this will wrap around
  (( PERIODS++ ))
}

async_register_callback main update_ext_ip_cb

add-zsh-hook periodic update_periods
add-zsh-hook periodic update_ext_ip

# Man/info/zman/zeal {{{

#zinit ice lucid wait"4"\
#  pick"colored-man-pages.plugins.zsh" 
#zinit snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh

typeset -TUgx MAN man=( #{{{
  "$HOME"/.local/share/man
  /usr/local/share/man
  /usr/share/man
  "$man[@]"
) #}}}

typeset -TUgx INFO info=( #{{{
  "$HOME"/.local/share/info
  /usr/local/share/info
  /usr/share/info
  "$info[@]"
) # }}}

# }}}

# Setup Colors {{{
# ================

autoload -URz colors && colors

# Where the colour configuration is stored
ZSH_INSTANCE[COLOUR_CACHE]=$ZSH_INSTANCE[CACHE_DIR]/colours.zsh

# Try harder to source appropriate termcap/terminfo
#zinit load "chrissicool/zsh-256color"

# Associative array containing easy access to colours and their light variant.
zinit load zpm-zsh/colors

# Add --color=auto
zinit load zpm-zsh/colorize

# Set appropriate dircolors
#zinit ice \
#  atclone'
#    echo hi > $ZDOTDIR/foobar
#    [[ ./LS_COLORS -nt $ZSH_INSTANCE[COLOUR_CACHE] ]] && {
#      # (( $+commands[dircolors] )) || return;
#      dircolors -b ./LS_COLORS > $ZSH_INSTANCE[COLOUR_CACHE];
#      zcompile -Uz $ZSH_INSTANCE[COLOUR_CACHE];
#    }
#  ' \
#  atpull'%atclone' \
#  pick'$ZSH_INSTANCE[COLOUR_CACHE]' \
#  atload'zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"' \
#  nocompile'!'
#cols_file="$ZINIT[PLUGINS_DIR]/trapd00r---LS_COLORS/LS_COLORS"
#echo $cols_file
#[[ -f $ZSH_INSTANCE[COLOUR_CACHE].zwc ]] || {
#  [[ $cols_file -nt $ZSH_INSTANCE[COLOUR_CACHE].zwc ]] && {
#    # (( $+commands[dircolors] )) || return;
#    echo foobar
#    dircolors -b ${(P)cols_file} > $ZSH_INSTANCE[COLOUR_CACHE];
#    zcompile -Uz $ZSH_INSTANCE[COLOUR_CACHE];
#  }
#}
#source $ZSH_INSTANCE[COLOUR_CACHE]
#zinit ice atpull'dircolors -b ./LS_COLORS > $ZSH_INSTANCE[CACHE_DIR]/colors_cmds' nocompile'!' pick'$ZSH_INSTANCE[CACHE_DIR]/colors_cmds' atload'zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"'
#zinit load trapd00r/LS_COLORS

zinit ice atclone"dircolors -b LS_COLORS > clrs.zsh" \
    atpull'%atclone' pick"clrs.zsh" nocompile'!' \
    atload'zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"'
zinit load trapd00r/LS_COLORS


zinit ice wait"3" # zpcominit performed in autopair
zinit load zdharma/fast-syntax-highlighting

# ====================
# End Setup Colors }}}

# Setup History {{{
# =================

export DIRSTACKSIZE=12

# History
setopt APPEND_HISTORY       # Append to $HISTFILE, rather than replacing
setopt HIST_IGNORE_SPACE    # Don't append commands prefixed with whitespace
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY   # Append commands to history immediately
setopt SHARE_HISTORY        # (Update &) Share the history file between instances
setopt HIST_FIND_NO_DUPS    # Store (but don't show) duplicates

export HISTFILESIZE=50000
export SAVEHIST=50000
export HISTSIZE=10000
export HISTCONTROL=ignorespace
export HISTFILE=$ZSH_INSTANCE[CACHE_DIR]/history

# Ensure flushing of history
#export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"

export HISTORY_EXCLUDE_PATTERN="^ykchalresp|$HISTORY_EXCLUDE_PATTERN"
zinit ice lucid wait'3'
zinit load jgogstad/passwordless-history

# Craft new commands from history
zinit ice lucid wait'3'
zinit load psprint/zsh-cmd-architect
# =====================
# End Setup History }}}

# Input {{{

# dot magic {{{
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^H' backward-delete-char

zinit wait'5' autoload'#manydots-magic' atload'manydots-magic' for knu/zsh-manydots-magic
#autoload -Uz manydots-magic
#manydots-magic

# }}}

# autosuggestions {{{

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=1
#ZSH_AUTOSUGGEST_MANUAL_REBIND=1
#To re-bind widgets, run _zsh_autosuggest_bind_widgets.

bindkey '^ ' autosuggest-accept

zinit ice \
    wait'1' \
    atload'_zsh_autosuggest_start'
zinit load zsh-users/zsh-autosuggestions

# }}}

# completions {{{
#zinit ice lucid wait'0' blockf as"completion"
#zinit snippet https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker

#zinit ice lucid from"gh" wait'0' svn blockf as"completion"
#zinit snippet zsh-users/zsh-completions/trunk/src
#
#zinit ice lucid from"gh" wait'0' svn blockf as"completion" pick"_git_annex"
#zinit snippet Schnouki/git-annex-zsh-completion

zinit ice lucid wait'0' svn blockf pick"completion.zsh" src"git.zsh"
zinit snippet OMZ::lib

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$HOME/.zcompcache"
zstyle ':completion:*' list-colors $LS_COLORS
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
zstyle ':completion:*' rehash true
# }}}

# vi mode {{{

MODE_INDICATOR_VIINS='%F{15}<%F{8}INSERT<%f'
MODE_INDICATOR_VICMD='%F{10}<%F{2}NORMAL<%f'
MODE_INDICATOR_REPLACE='%F{9}<%F{1}REPLACE<%f'
MODE_INDICATOR_SEARCH='%F{13}<%F{5}SEARCH<%f'
MODE_INDICATOR_VISUAL='%F{12}<%F{4}VISUAL<%f'
MODE_INDICATOR_VLINE='%F{12}<%F{4}V-LINE<%f'



MODE_CURSOR_VIINS="#00ff00 blinking bar"
MODE_CURSOR_REPLACE="$MODE_CURSOR_VIINS #ff0000"
MODE_CURSOR_VICMD="green block"
MODE_CURSOR_SEARCH="#ff00ff steady underline"
MODE_CURSOR_VISUAL="$MODE_CURSOR_VICMD steady bar"
MODE_CURSOR_VLINE="$MODE_CURSOR_VISUAL #00ffff"

#setopt PROMPT_SUBST
## Note the single quotes
#RPS1='${MODE_INDICATOR_PROMPT} ${vcs_info_msg_0_}'

# Add to .zshrc, before this plugin is loaded:
# Use Control-D instead of Escape to switch to NORMAL mode
#export KEYTIMEOUT=1
VIM_MODE_VICMD_KEY='^D'

VIM_MODE_INITIAL_KEYMAP=last

zinit ice lucid wait"4" # should load after zsh-fast-syntax-highlighting
zinit load softmoth/zsh-vim-mode

bindkey -v
#}}}

# autopair {{{

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

zinit ice lucid \
    wait'4' \
    atinit"zpcompinit;zpcdreplay" 
zinit load hlissner/zsh-autopair

# }}}

# emojis {{{

# Application for selecting emoji
#export EMOJI_CLI_DICT=
export EMOJI_CLI_FILTER='fzf-tmux -d 15%:fzf:peco:percol'
#export EMOJI_CLI_KEYBIND=
#export EMOJI_CLI_USE_EMOJI
zinit ice lucid wait'4'
zinit load b4b4r07/emoji-cli

# '$em'_-variables containing textual emojis (kamoji?)
zinit ice lucid wait'4'
zinit load MichaelAquilina/zsh-emojis

# Unicode characters
zinit ice lucid wait'4'
zinit load zpm-zsh/figures

#}}}

# }}}

# Additional Gadgets {{{

zinit ice wait'4'
zinit light KKRainbow/zsh-command-note.plugin

zinit ice lucid wait'4'
zinit light Cloudstek/zsh-plugin-appup

# En-/Decrypt files and directories
# gpg-{en,de}crypt commands
zinit ice wait'4'
zinit load Czocher/gpg-crypt

zinit ice wait'4'
zinit load StackExchange/blackbox

# }}}

# Applications {{{
# ================

# TODO Can't remember why these were needed.
## Eclipse
#(( $+commands[eclipse] )) && export ECLIPSE_HOME="/usr/share/eclipse"
#
## Ant
#(( $+commands[ant] )) && export ANT_HOME="/usr/share/apache-ant"

# zsh parameter completion for the dotnet CLI
_dotnet_zsh_complete()
{
  local completions=("$(dotnet complete "$words")")

  reply=( "${(ps:\n:)completions}" )
}

compctl -K _dotnet_zsh_complete dotnet

# ===
# }}}



#source "$ZDOTDIR/term-env.zsh"
#source "$ZDOTDIR/colours.zsh"
#source "$ZDOTDIR/plugins.zsh"
#source "$ZDOTDIR/applications.zsh"
#source "$ZDOTDIR/history.zsh" # done as plugin
#source "$ZDOTDIR/hooks.zsh"
#source "$ZDOTDIR/prompt.zsh"
zplugin ice depth=1; zplugin light romkatv/powerlevel10k

source "$ZDOTDIR/aliases.zsh"
#source "$ZDOTDIR/keys.zsh"

#zinit wait'4' lucid atload'zicompinit; zicdreplay;' blockf for \
#  zsh-users/zsh-completions


# From: https://unhexium.net/zsh/how-to-check-variables-in-zsh/
def () {
  [[ ! -z "${(tP)1}" ]]
}

# Start SSH key agent
# Maybe use this instead: https://github.com/bobsoppe/zsh-ssh-agent
# And incorporate this:
# https://github.com/TBSliver/zsh-plugin-tmux-simple
if ! def SSH_AUTH_SOCK && ! def SSH_AGENT_PID ]]; then
  # TODO remove print when done
  echo Starting new SSH agent
  eval $(ssh-agent) > /dev/null

fi

zinit creinstall $ZSH_INSTANCE[COMPLETIONS_DIR]

# Clean up {{{
# ============

# Unload the functions that were only required for setting up shell
#unfunction ${s.$ZSH_INSTANCE[FUNC_SEP].)ZSH_INSTANCE[RC_FUNCS]:t}
#array_remove fpath $ZSH_INSTANCE[ENV_FUNCS_FILE]
#array_remove fpath $ZSH_INSTANCE[RC_FUNCS_FILE]

# ================
# End Clean Up }}}

cdpath+=( #{{{
  $HOME
  $HOME/{2015-2016,2016-2017,2018-2019}
  "$cdpath[@]"
) # }}}


function t () {
  if test -z $TMUX; then
    if ! tmux attach; then
      command tmux new-session \; new-window "tmux set-option -ga terminal-overrides \",$TERM:Tc\"; tmux detach"
      command tmux attach
    fi
  fi
}

# To customize prompt, run `p10k configure` or edit ~/.zsh/.p10k.zsh.
[[ ! -f ~/.zsh/.p10k.zsh ]] || source ~/.zsh/.p10k.zsh

# vim: ft=zsh et tw=78 ts=2 sts=2 sw=2 cc=80 fdm=marker
