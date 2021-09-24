#!/bin/zsh
#
# The environment that all ZSH invocations will operate in
#

# Store some info about this zsh session
typeset -Augx ZSH_INSTANCE

# Set configuration directory
export ZDOTDIR="$HOME/.zsh"

# Language setup
export LANG=en_GB.UTF-8
export LANGUAGE=en_GB #en_GB:en_US:en_DK:da_DK:da
export LOCALE=en_GB.UTF-8 #:en_UK.UTF-8:en_US.UTF-8

# Operating System {{{
# --------------------
() {
  (( $+ZSH_INSTANCE[OS]  )) && return

  local os=Unknown
  # TODO add cases for solaris & hp-ux
  # TODO maybe make more fine-grained
  # TODO Could also shorten the tried if-statements by using $OSTYPE (not sure
  #      what sets that, though)
  if   (( $+commands[pacman]  )); then os=Linux/ArchLinux
  elif (( $+commands[dpkg]    )); then os=Linux/Debian
  elif (( $+commands[rpm]     )); then os=Linux/RedHat
  elif (( $+commands[apk]     )); then os=Linux/Alpine
  elif (( $+commands[portage] )); then os=Linux/Gentoo
  elif (( $+commands[nix]     )); then os=Linux/NixOS
  elif (( $+commands[ports]   )); then os=BSD
  elif (( $+commands[brew]    )); then os=MacOS
  else
    # Select the ID field's value
    # TODO I'm sure this can be done more efficiently.
    case "${(L)${(ML)${(pf@)$(</etc/os-release)}:#ID=*}/ID=}" in
      qubes  ) os=QubesOS-dom0/Fedora     ;;
      arch   ) os=Linux/ArchLinux         ;;
      manjaro) os=Linux/ArchLinux/Manjaro ;;
      fedora ) os=Linux/RedHat/Fedora     ;;
      debian ) os=Linux/Debian            ;; # Whonix also sets this
      ubuntu ) os=Linux/Debian/Ubuntu     ;;
    esac

    # Necessary to call external command, but let's only do it once.
    case ${(L)$(uname)} in
      darwin ) os=MacOS         ;;
      mingw* ) os=Windows/MinGW ;;
      cygwin*) os=Windows/Cygwin;;
      msys*  ) os=Windows/Other ;;
    esac

    [[ -f /usr/share/qubes/marker-vm ]] && os=QubesOS-domU/$os
  fi

  ZSH_INSTANCE[OS]=$os
}
# -------------------------
# End Operating Systems }}}

# Paths {{{
# =========
# Various lookup paths for other function

# freedesktop.org (XDG) paths {{{
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
typeset -TUgx XDG_CONFIG_DIRS xdg_config_dirs=(
  ${XDG_CONFIG_HOME}
  /usr/local/etc
  /etc/xdg
  /etc
  "$xdg_config_dirs[@]"
)

export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
typeset -TUgx XDG_DATA_DIRS xdg_data_dirs=(
  ${XDG_DATA_HOME}
  /usr/local/share
  /usr/share/
  "$xdg_data_dirs[@]"
)
#}}}

# Instance Paths {{{
ZSH_INSTANCE[CACHE_DIR]="$XDG_CACHE_HOME/zsh"

# TODO this is unnecessary
ZSH_INSTANCE[TMP_DIR]=$TMPPREFIX

ZSH_INSTANCE[FUNCTIONS_DIR]=$ZDOTDIR/functions

ZSH_INSTANCE[FUNC_SEP]=:
# Function cache for functions that are used in environment setup
ZSH_INSTANCE[ENV_FUNCS_FILE]="$ZSH_INSTANCE[CACHE_DIR]/env_func.zsh.zwc"
# Function cache for functions that are used in runtime configuration
ZSH_INSTANCE[RC_FUNCS_FILE]="$ZSH_INSTANCE[CACHE_DIR]/rc_func.zsh.zwc"
# Function cache for functions that should be available in shell
ZSH_INSTANCE[SHELL_FUNCS_FILE]="$ZSH_INSTANCE[CACHE_DIR]/shell_func.zsh.zwc"
# }}}

typeset -TUgx PATH path=( #{{{
  "$HOME/bin"
  "$HOME/.local/sbin"
  "$HOME/.local/bin"
  "$HOME/.dotnet/tools"
  "$HOME/.gem/ruby/3.*/bin"
  "$HOME/.gem/ruby/2.6.*/bin"
  /usr/libexec/qubes-pass
  /usr/local/sbin
  /usr/local/bin
  /usr/local/games
  /usr/sbin
  /usr/bin
  /sbin
  /bin
  # TODO not really sure what this could contain that I would possibly want.
  #      maybe remove?
  "$path[@]"
)
#rationalize_path path
#}}}

typeset -TUgx MODULE_PATH module_path=( #{{{
  $ZDOTDIR/modules
  /usr/lib/zsh/$ZSH_VERSION
  "$module_pat[@]"
) #}}}

typeset -TUgx FPATH fpath=( #{{{
  # Start with compiled zwc-files even if not present
  $ZSH_INSTANCE[ENV_FUNCS_FILE]
  $ZSH_INSTANCE[RC_FUNCS_FILE]
  $ZSH_INSTANCE[SHELL_FUNCS_FILE]
  # TODO
  $( [[ $ZSH_INSTANCE[OS] =~ QubesOS-dom0/ ]] && $ZSH_INSTANCE[FUNCTIONS_DIR]/qubes/dom0)
  $( [[ $ZSH_INSTANCE[OS] =~ QubesOS-domU/ ]] && $ZSH_INSTANCE[FUNCTIONS_DIR]/qubes/domU)
  $ZSH_INSTANCE[FUNCTIONS_DIR]/**/*
  $ZSH_INSTANCE[FUNCTIONS_DIR]
  /usr/share/zsh/$ZSH_VERSION/functions
  "$fpath[@]"
) #}}}

# From whichever source is available.
autoload -URzd autoload_and_compile
ZSH_INSTANCE[ENV_FUNCS]="./autoload_and_compile:"

# =============
# End Paths }}}

# Autoloaded functions {{{
# ========================
() {
  local env_funcs=(
    # Prepend with ':/' to just autoload function
    ./compile_and_load
    ./rationalize_path
    ./on_ssh_connection
  )

  autoload_and_compile $ZSH_INSTANCE[ENV_FUNCS_FILE] $env_funcs > /dev/null 2>&1

  ZSH_INSTANCE[ENV_FUNCS]+="${(j.:.)env_funcs}"
}
# ============================
# End Autoloaded Functions }}}

# Session Type {{{
# ================
(( $+ZSH_INSTANCE[SESSION] )) && return \
  || { on_ssh_connection && ZSH_INSTANCE[SESSION]=remote/ssh } \
  || case ${(L)$(cat /proc/$PPID/cmdline)} in
    # TODO don't know if I should change patterns to _* (not necessary on
    #      current system)
    tmux  ) ZSH_INSTANCE[SESSION]=local/tmux;;
    screen) ZSH_INSTANCE[SESSION]=local/screen;;
    *vim  ) ZSH_INSTANCE[SESSION]=local/vim;;
    zsh   ) ZSH_INSTANCE[SESSION]=local/subshell;; # Could just check ZSH_SUBSHELL
    *     ) 

      function get_tgid () {
        # TODO check if /proc/pid exists
        echo "${${(@f)$(cat /proc/$1/status)}[6]:5}"
      }

      #local curr_pid=$$
      #while [[ $curr_pid -gt 1 ]]; do
      #  check_connection 
      #  curr_pid=$(get_tgid $curr_pid)
      #done
  

      ZSH_INSTANCE[SESSION]=local;; # We'll assume local
  esac
# ====================
# End Session Type }}}

#|| (on_telnet_connection && ZSH_INSTANCE[CONN]="remote/telnet") \

# According to zinit README this is needed on ubuntu.
# https://github.com/zdharma/zinit#disabling-system-wide-compinit-call-ubuntu
skip_global_compinit=1

# TODO Consider making a unified way of inputting these, since so similar
#      Something like:
#prioritised_app () {
#  (( $+EDITOR )) && return;
#
#  for cmd in $*; do
#    (( $+commands[$cmd] )) && {
#      export EDITOR=$cmd
#      return
#    }
#  done
#  unset EDITOR
#}
# Browser {{{
# ===========
() {
  # Already set - just use that.
  (( ${+BROWSER} )) && return;

  local tmp
  if (( ${+DISPLAY} )); then # We have a GUI environment
    ((( $+commands[qutebrowser] )) && tmp=qutebrowser ) || \
    ((( $+commands[vimb]        )) && tmp=vimb        ) || \
    ((( $+commands[uzbl]        )) && tmp=uzbl        ) || \
    ((( $+commands[firefox]     )) && tmp=firefox     ) || \
    ((( $+commands[surf]        )) && tmp=surf        ) || \
    ((( $+commands[chromium]    )) && tmp=chromium    ) || \
    ((( $+commands[midori]      )) && tmp=midori      ) || \
    ((( $+coomands[chrome]      )) && tmp=chrome      ) || \
    unset tmp
  else # No GUI. Select a good terminal browser.
    ((( $+commands[links])) && tmp=elinks ) || \
    ((( $+commands[w3m]  )) && tmp=w3m    ) || \
    ((( $+commands[lynx] )) && tmp=lynx   ) || \
    ((( $+commands[links])) && tmp=links  ) || \
    ((( $+commands[emacs])) && tmp=emacs  ) || \
    unset tmp
  fi

  # Found a browser. Set and export it.
  (( $+tmp )) && export BROWSER=$tmp
}
# ===============
# End Browser }}}

# Editor {{{
# ==========
() {
  (( $+EDITOR )) && return;

  local tmp
  if   (( $+commands[nvim]  )); then tmp=nvim
  elif (( $+commands[vim]   )); then tmp=vim
  elif (( $+commands[vi]    )); then tmp=vi
  elif (( $+commands[emacs] )); then tmp=emacs
  elif (( $+commands[nano]  )); then tmp=nano
  else unset tmp
  fi

  (( $+tmp )) && export EDITOR=$tmp \
              || unset  EDITOR
}

() {
  # Only set if not already set and if has GUI running
  { [[ -v VISUAL ]] || [[ ! -v DISPLAY ]] } && return;

  local tmp
  if   (( $+commands[nvim-qt] )); then tmp=nvim-qt
  elif (( $+commands[neoclide])); then tmp=neoclide
  elif (( $+commands[gvim]    )); then tmp=gvim
  elif (( $+commands[atom]    )); then tmp=atom
  elif (( $+commands[tea]     )); then tmp=tea
  elif (( $+commands[code]    )); then tmp=code
  else unset tmp
  fi

  (( $+tmp )) && export VISUAL=$tmp \
              || unset  VISUAL
}
# ==============
# End Editor }}}

() { # {{{ PAGER
  (( ${+PAGER} )) && return;

  [[ $+commands[less] ]] && {
    export PAGER=$commands[less]
    export LESS=" -x -R"
    export LESSOPEN="| $commands[src-hilite-lesspipe.sh] %s"
    export LESSHISTFILE=/dev/null
  } || export PAGER=$commands[more] \
    || unset PAGER
} # }}}

# Where my passwords at
# TODO set up for desktop as well
[[ "$ZSH_INSTANCE[OS]" =~ QubesOS/* ]] && export QUBES_PASS_DOMAIN=pass

# Prevents some Java hickups (in xmonad)
export XLIB_SKIP_ARGB_VISUALS=1

# Commands {{{

# Mail
export MAIL="$HOME/Mail/inbox"

# LaTeX local installs
export TEXMFHOME="$HOME/.texmf"

# Devel {{{

# Java {{{
# Path to current Java version
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk
export _JAVA_OPTIONS=-Djava.io.tmpdir=$HOME/.local/java/tmp
#export CLASSPATH=$CLASSPATH:~/.eclipse/plugins/org.junit_4.12.0.v201504281640/junit.jar
# }}}

# Path to config for interactive python shells
export PYTHONSTARTUP="$HOME/.pythonrc"

# Use XDG-style paths for ghcup
export GHCUP_USE_XDG_DIRS=ON

# Path to go setup
export GOPATH="$HOME/.go"

# Of course this is opt-out... As$hole EvilCorp
export DOTNET_CLI_TELEMETRY_OPTOUT=1
#export MSBuildSDKsPath=$( echo /usr/share/dotnet/sdk/5.*/Sdks );

# }}}

#typeset -A GITHUB_CONFIG=(
#  [HOST]=github.itu.dk
#  [USER]=pawp
#  [TOKEN]=$(gpg --decrypt $HOME/.github_token.itu.gpg)
#)

set_github_info () {
  [[ $# == 3 ]] || return 1

  export GITHUB_HOST=$1
  export GH_HOST=$1
  export GITHUB_USER=$2
  export GITHUB_TOKEN=$3
  export GITHUB_ENTERPRISE_TOKEN=$3
}
case itu in
  itu) set_github_info \
    github.itu.dk \
    pawp \
    $(cat $HOME/.github_pat_itu);;
  pers*) set_github_info \
    github.com \
    pspeder \
    $(cat $HOME/.github_pat_personal);;
esac
# }}}

# Clean up {{{
# ============

#unfunction ${s.$ZSH_INSTANCE[FUNC_SEP].)ZSH_INSTANCE[ENV_FUNCS]:t}

# ================
# End Clean up }}}

# vim: ft=zsh et tw=78 ts=2 sts=2 sw=2 cc=80 fdm=marker
