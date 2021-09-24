#!/bin/zsh
# NOTE Should use either this or .zprofile - this one runs after .zshrc.


# Execute code that does not affect the current session in the background.
# {
#     # Compile the completion dump to increase startup speed.
#     dump_file="$ZDOTDIR/.zcompdump"
#     [[ "$dump_file" -nt "${dump_file}.zwc" || ! -s "${dump_file}.zwc" ]] && zcompile "$dump_file"
#     unset dump_file
# 
# } &!

# Start Keychain to manage ssh keys
# TODO put these in Qubes GPG/pass domain and retrieve with Qubes IPC proto
() {
  # Don't do anything if keys already loaded
  if [[ ${+KEYCHAIN_PID} && $(pid_to_cmd "$KEYCHAIN_PID") == keychain* ]]
  then echo "Keychain on PID=$KEYCHAIN_PID"
  else
    local -a my_agent_keys
    my_agent_keys=(
      # For general purposes
      id_rsa id_dsa id_ed25519
      # For University logins
      id_itu id_itu2
      # For home use
      id_psp id_pspmail id_config id_pawhome_rsa id_pi_ed25519
      # For development
      id_devel_gh id_bitbucket_ed25519 id_bitbucket_rsa id_github_ed25519
    )

    if [[ -s "$HOME/.ssh" ]]
    then eval $(keychain --eval --agents ssh -Q --quiet && export KEYCHAIN_PID="$PPID")
    else echoerr "No $HOME/.ssh folder found. Please make one and add some ssh keys."
    fi
  fi
}

## And then run the X Window System if possible
#if [[ $(tty) == /dev/tty1 && -z "$DISPLAY" ]]; then
#    exec startx -- vt1 &>/dev/null
#    logout
#fi
# Otherwise just run `startx`

# vim: ft=zsh et tw=78 sw=2 ts=2 sts=2 cc=80
