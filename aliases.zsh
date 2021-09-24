#!/bin/zsh

# Path Stuff {{{
# ==============

if [[ $+commands[exa] ]]; then
  alias ls='exa --group-directories-first --icons --classify'
  alias la='ls -a'
  alias lsa='ls -a'
  # TODO for long listings
  #exa --color-scale --git --inode --time-style=long-iso --binary --blocks --group --modified --long --git-ignore --links
  alias ll='ls -l'
  alias lt='ls --tree'
  alias ldot='ls .*'
elif [[ $+commands[lsd] ]]; then
  alias ls='lsd --group-dirs=first --classify '
  alias la='ls -a'
  alias lsa='ls -a'
  alias ll='ls -l --total-size'
  alias lt='ls --tree'
  alias ldot='ls .*'
else
  alias ls='ls -hXp --group-directories-first --color=auto --indicator-style=classify'
  alias lsa='ls -hAXp --group-directories-first --color=auto --indicator-style=classify'
  alias lsl='ls -lhAXp --group-directories-first --time-style=long-iso --color=auto --indicator-style=classify'
  alias lsll='ls -lhAXpiZ --group-directories-first --file-type --time-style=long-iso --color=auto --indicator-style=classify'
  alias lsls='ls -lhAGp --group-directories-first --time-style=iso --color=auto'
  alias ldot='ls --human-readable --group-directories-first --time-style=iso --file-type --color=auto --indicator-style=classify .*'
fi

alias mkdir='mkdir -p'

alias mv='mv -i'
alias rm='rm -I --preserve-root'

alias_if_present rscp rsync ---partial --progress --append --rsh=ssh -r -h
alias_if_present rsmv rsync ---partial --progress --append --rsh=ssh -r -h --remove-sent-files

[ "$ZSH_INSTANCE[OS]" =~ Linux/QubesOS/* ] && {
  alias_if_present qcp qvm-copy
  alias_if_present qmv qvm-move
}

alias_sudo chown chown '--preserve-root'
alias_sudo chmod chmod '--preserve-root'
alias_sudo chgrp chgrp '--preserve-root'

#alias path='echo -e ${PATH//:/\\n}'
# ==================
# End Path Stuff }}}

# Package Management {{{
# ======================

[[ -z $OPERATING_SYSTEM ]] && (( $+commands[lsb_release] )) \
  && typeset -g OPERATING_SYSTEM=$(lsb_release -i)

() {
  local search
  local install
  local uninstall
  local update
  local upgrade
  local upd_and_upg
  
  # TODO this sorta seems like abuse of the aliasing mechanism
  if [[ "$OPERATING_SYSTEM" = Arch ]]; then
    search='yay'
    install='yay -S'
    uninstall='yay -Rns'
    update='yay -Syy'
    upgrade='yay -Su'
    upd_and_upg='yay -Syyu'
  elif [[ "$OPERATING_SYSTEM" = Fedora ]] || \
       [[ "$OPERATING_SYSTEM" = CentOS ]]; then
    # TODO should probably check if dnf is available, else use yum
    search='dnf search'
    install='sudo dnf install'
    uninstall='sudo dnf remove'
    update='sudo dnf makecache'
    upgrade='sudo dnf upgrade'
    upd_and_upg='sudo dnf upgrade'
  elif [[ "$OPERATING_SYSTEM" = Ubuntu ]] || \
       [[ "$OPERATING_SYSTEM" = Debian ]]; then
    search='apt-cache search'
    install='sudo apt-get install install'
    uninstall='sudo apt-get '
    update='sudo apt-get update'
    upgrade='sudo apt-get upgrade'
    upd_and_upg='sudo apt-get update && sudo apt-get upgrade'
  fi
  
  alias ss="$search"
  alias ii="$install"
  alias ui="$uninstall"
  alias upd="$update"
  alias upg="$upgrade"
}

# ==========================
# End Package Management }}}

# System/Daemon Control {{{
# =========================
alias hh=hstr

alias df='df -H'

alias du='du -ch'
alias du1='du -d 1'

alias most='du -hsx * | sort -rh | head -10'

alias partusage='df -hlT --exclude-type=tmpfs --exclude-type=devtmpfs'

# This is very clever, Paw.... but also stupid as shit for ps:
# ps k +%cpu
sort_with_header () {
  local sort_cmd="$1"
  local lines=( "${(f)$(${(s: :)2})}" )

  echo $lines[1] # output header
  echo ${(F)lines[2,$#lines]} | ${(s: :)sort_cmd} # output everything after header, sorted
}

alias pscpu='ps auxf | sort -n -k 3'

### This top one was from some internet site loooooong ago. not necessary.
#alias psmem='ps auxf | sort -nr -k 4'
alias psmem='ps aux k+%mem'
alias psmem2='sort_with_header "sort -n -k 4" "ps aux"'

alias meminfo='free -m -l -t'

alias ps2='ps -f | head -1; ps -ef | grep -v $$ | grep -i'

alias mounts='mount | column -t'

if (( $+commands[systemctl] )); then
  alias_sudo sysc  systemctl
  alias_sudo shutd systemctl poweroff
  alias_sudo reb   systemctl reboot
  alias_sudo susp  systemctl susped

  alias_sudo svcen   systemctl enable
  alias_sudo svcdis  systemctl disable
  alias_sudo svcnow  systemctl start
else
  alias_sudo shutd shutdown '-h now'
  alias_sudo reb shutdown '-r now'

  # TODO actually find these out. I'm ashamed I don't know the init-script
  # equivalent.
  #alias svcen=
  #alias svcdis=
  #alias svcnow=init
fi
# =============================
# End System/Daemon Control }}}

# Date/Time Related {{{
# =====================

alias isodate='date "+%g%m%d-%H%M"'
alias isodate2='date -u +"%Y-%m-%dT%H:%M:%SZ"'

# =========================
# End Date/Time Related }}}

# Network Related {{{
# ===================

alias ping5='ping -c 5'
alias fastping='ping -c 100 -i .2'
alias_sudo ports netstat '-tulnap'
alias_sudo iptlist iptables -L -n -v --line-numbers
alias wget='wget -c'

# =======================
# End Network Related }}}

# Crypto Related {{{
# ==================
alias sha1='openssl sha1'
alias md5='openssl md5'
# ======================
# End Crypto Related }}}

# Development {{{
# ===============

alias g='git'

# Run build-script
alias b='./build'

# Set/Extract clipboard entry (useful when piping)
alias cpset='xsel --clipboard --input'
alias cpext='xsel --clipboard --output'

# Show text file without comment (#) lines (NB: scripts won't show she-bang)
alias nocomment='grep -Ev '\''^(#|$|\/\*|!)'\'''

# Give tmux full unicode support
alias tmux='tmux -u'

# ML
alias_if_present mosml rlwrap -P full
alias_if_present smlnj rlwrap 

alias addon-sdk="cd /opt/addon-sdk && source bin/activate; cd -"
# Dotnet core server
alias dotnet_singleshot='dotnet -p:UseRazorBuildServer=false -p:UseSharedCompilation=false /nodeReuse:false'

# ===================
# End Development }}}

# vim: ft=zsh tw=78 et ts=2 sts=2 sw=2 cc=80 fdm=marker
