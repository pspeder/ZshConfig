#!/bin/zsh

autoload -Uz add-zsh-hook


# Prompt {{{
# ==========
() {
  local integer err=1\
                user=2\
                remote=3\
                path=4\
                ending=5

  if (( LINES > 20 )) || (( PROMPT_STYLE[lines] == 2 ))) then
    psvar[err] = 
  else

    # Prepare a single line prompt
    psvar[user]='$username'
  fi

  psvar[err]='%(?..(%B%F{red}E%f%b%F{white}%?%f) )'  # (E2)


  length=((COLUMNS))
  if ((length > 120)); then

  elif (( length > 100 )); then
    tprompt_max=((length))
    lprompt_max=((40))
    rprompt_max=((20));
  elif (( length > 80  )); then
    tprompt_max=((length))
    lprompt_max=((40))
    rprompt_max=((20));
  elif (( length > 40  )); then tprompt_max=40; lprompt_max=15; rprompt_max=0;
  else tprompt_max=((COLUMNS)); lprompt_lvl=2; rprompt_lvl=2
  fi

}


prompt[ll]=\
  # Error from prev. command (note trailing ws)
  #"%(?..(%B%F{red}E%f%b%F{white}%?%f) )"\
  $(prev_cmd_error)
  # Add machine and user name if this is an SSH conn
  $(user_indicator)
  $(remote_indicator)
  $(prompt_path "$prompt_style") # including stuff for shrinking down to <P>
  $(ll_ending)">"
prompt[lr]="< $lines$(prompt_project_info $project_style)[$vimode]"


#user@edu-itu:~/CSP                           S:1 U:3 (B:master@ac62233 A/B:1/0)
#P:Assignment01/Server >                                     < (l:1092) [NORMAL]
#
#
#user@edu-itu:~/C/A/S/Account(700)   CSP01   ⌂:../.. | python2 | ⋮ 20 | ✓ 102/✗ 20
#(E1) [NORMAL] >                       < l:1092 | master@ac62233 | S:1 U:3 A/B:1/0
#
#
#user@edu-itu:~/C/A/S/Account(700)   CSP01   ⌂:../.. | python2 | ⋮ 20 | ✓ 102/✗ 20
#(E1) [NORMAL] >                                                        < (l:1092)
#
#
#user@edu-itu:~/CSP/Assignment01/Server/Account  
#(E1) [NORMAL] >                           < master@ac62233 (S:1 U:3 A/B:1/0)
#
#
#user@edu-itu              P:CSP01/Server/Account     master@ac62233 (S:1 U:3 A/B:1/0)
#(E1) [NORMAL] (l:1092) >            < [ python | ⋮ 20 | ✓ 1002/✗ 20 ]

prompt_path () {
  local retval

  case "$1" in
    off) retval="";;
    shortest) retval="%1d";;
    short) retval=$(collapsed_working_dir);;
    normal) retval="%~";;
    long) retval="%d";;
  esac

  while (( $# > 0 )); do
    case "$1" in
      symlinks) test $(pwd_has_symlinks) && retval+="→${PWD:A}";;
      permissions) retval+="($(stat --printf='%a' .))"
    esac
  done

  return retval
}
# ===
# }}}

project[home_dir_rel]

config[top_left]="$name@$machine:$(perms)$(prompt_path)$(symlink)"
config[top_middle]="$project[name]%(project[home_dir_rel]. (⌂ $project[home_dir_rel]).) [ $project[lang] | ≡  $project[sloc] | ⋮ $project[todos] | ✓ / ✗  $project[tests_passing] / $project[tests_failing] ]"
config[top_right]=""
config[left]=("[" vimode[CURRENT] "] ")
config[right]="($vcs)"


# left mode [VIMODE] >


# Top = disabled, left = nomral, right = disabled
# [MODE] foobar

# 


# + name@machine[SSH]:~/path --- python - todos - --- vcs_info
# [MODE] >


case "$ZSH_VI_LENGTH" in
  "short")
    vimode[viins]="I"
    vimode[vicmd]="N"
    vimode[vivis]="V"
    #vimode[virepl]="R"
    ;;
  "long")
    vimode[viins]="INSERT"
    vimode[vicmd]="NORMAL"
    vimode[vivis]="VISUAL"
    #vimode[virepl]="REPLACE"
    ;;
esac



#function update_mode () {
#  case "$1" in
#    "main")
#    "viins")
#    "vicmd")
#  esac
#}

# From https://dougblack.io/words/zsh-vi-mode.html
function zle-line-init zle-keymap-select {
    VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]% %{$reset_color%}"
    RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $(git_custom_status) $EPS1"
    # Will reexpand (all) prompt vars
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

#zle reset-prompt

# test shell width and set info accordingly
prompt_init () {
  local integer command_cols_min=40
  local integer command_cols tprompt_max lprompt_max rprompt_max length

  length=((COLUMNS))
  if ((length > 120)); then
    create_top_prompt length
    tprompt_max=((length))
    lprompt_max=((40))
    rprompt_max=((20));
  elif (( length > 100 )); then
    tprompt_max=((length))
    lprompt_max=((40))
    rprompt_max=((20));
  elif (( length > 80  )); then
    tprompt_max=((length))
    lprompt_max=((40))
    rprompt_max=((20));
  elif (( length > 40  )); then tprompt_max=40; lprompt_max=15; rprompt_max=0;
  else tprompt_max=((COLUMNS)); lprompt_lvl=2; rprompt_lvl=2
  fi

  command_cols=(( length - lprompt_max - rprompt_max ))

  local integer diff=(( command_cols - command_cols_min ))
  if (( diff < 0 )); then
    ((lprompt_max-=diff))
    command_cols=$command_cols_min
  fi

  if ((lprompt_max)); then
    integer diff=((lprompt_max - command_cols))
    lprompt_max=((lprompt_max - diff))
  rprompt_max=((length - lprompt_max - command_cols))

  case tprompt_lvl in
    #  
    2) prompt_info[ul]=""
       prompt_info[um]=""
       prompt_info[ur]=""
       ;;
    1) prompt_info[ul]=""
       prompt_info[um]=""
       prompt_info[ur]=""
       ;;
    *) prompt_info[ul]=""
       prompt_info[um]=""
       prompt_info[ur]=""
       ;;
  esac

  case lprompt_lvl in
    # [MODE] path >
    2) prompt_info[ll]=""
       ;;
    # [MODE (single letter)] fishy_pwd >
    1) prompt_info[ll]=""
       ;;
    # [MODE (single letter)] dir>
    *) prompt_info[ll]=""
       ;;
  esac

  case rprompt_lvl in
    2) prompt_info[lr]=""
       ;;
    1) prompt_info[lr]=""
       ;;
    *) prompt_info[lr]=""
       ;;
  esac
  prompt_info[ul]=
  prompt_info[um]=
  prompt_info[ur]=
  prompt_info[ll]=
  prompt_info[lr]=

  if [ $(on_ssh_connection) ]; then
  fi

  typeset -A prompt_info


  if   ((COLUMNS <= 40))    # Small terminal, set small pwd, no history, ±N for vcs
  then
      pr_pwd=$(fishy_collapsed_wd)
      pr_his=""
  elif ((COLUMNS <= 75))    # half screen-width (151 cols); pwd_size=40, shrink vcs-info, no history
  then
      pr_pwd=""
      pr_his=""
  elif ((COLUMNS <= 100))   # pretty large; expand vcs info, show history, pts
  then
      pr_pwd=""
      pr_his=""
  else # larger terminals; expand vcs, history, pts, running jobs
  fi

  if ((COLUMNS >= 75)) # Half screen terminal (with current settings)
  then

  elif ((COLUMNS >= 100)) # Large terminal (~2/3*screen width), set full info
  then
      pr_pwd="%~"
      pr_his=""

  else # Really small terminal custom prompt would preferable here

  fi

  # Error message
  # If terminal width > 40 chars
  ([[ $COLUMNS -gt 40 ]] &&
    { pr_pwd="%3~";
      pr_his="%F{magenta}%h%f";
    }) ||\
    { # if less than 40 chars wide
      pr_pwd=$(fishy_collapsed_wd);
      pr_his="";
    }
  [[ $COLUMNS -gt 80 ]] && pr_pwd="%~"

  ([[ $(on_ssh_connection >/dev/null 2>&1) ]] && pr_mname="%B%F{yellow}%m%f%b") || pr_mname="%F{blue}%m%f"
}

environs=('in' 'autoenv' 'env')
project_root_patterns[source_direct]=""
function hook-set_project () {
  local project_root_patterns=()
  # define/add to in appropriate plugins
}

# Hooks
#add-zsh-hook chpwd hook-changed_pwd

function chpwd () {
  local env_file p
  local parents=(${(s:/:)PWD%/*})
  for (i = 0; i <= 0; i++) {
    p="/${(j:/:)parents:0:$i}"
    available=$p{${k(j:,:)envrionments}}

    if   [[ -s "$p/.in"      ]]; then env_file=".in"
    elif [[ -s "$p/.autoenv" ]]; then env_file=".autoenv"
    elif [[ -s "$p/.env"     ]]; then env_file=".env"
    else unset env_file
    fi
  }
}

function precmd () {
  title "zsh" "$USER@%m" "%55<...<%~"
}
add-zsh-hook precmd prompt-set_vars # PSx are set in prompt.zsh
 
function preexec () {
  title "$1" "$USER@%m" "%35<...<%~"
}

function periodic () {}
#add-zsh-hook periodic prompt-check_todos
#add-zsh-hook periodic source_autoenv_in

function zshaddhistory () {}

function zshexit () {}

# vim: ft=zsh et tw=78 ts=2 sts=2 sw=2 cc=80
