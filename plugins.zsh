#!/bin/zsh

# ZInit:
#
# load means track (enabling report and unload),
# light means don't track
# In turbo mode difference is neglible.
#
# snippet downloads single file directly from URL.
# You can use it to download (official) prezto and omz plugins more easily:
# snippet OMZ::plugins/git/git.plugin.zsh
# snippet PZT::modules/helper/init.zsh
#
# Add svn-ice to download multiple files:
# ice svn
# snippet PZT::modules/docker
#

ENABLED_PLUGINS=( # "zsh-hooks"
  # Add some functional programming to zsh
  functional
  # Git 
  git
  # History
  hstr
  # Less typing when using docker and vagrant
  appup
  # Directly en-/decrypt files and dirs
  gpg-crypt
	# Convenient use of GPG on team-projects
	blackbox
  # autojump and bd
  navigation
  # Craft new commands from history. Ctrl-T
  cmd-architect
  # Attach some comment to specific commands.
  cmd-note
  # Set up dircolors and (Z)LS_COLORS
  #colours
  # Autoenv TODO Requires quite a bit of setup still
  #environments
  # Completions
  completions # TODO setup completions options
  # Auto-suggestion
  autosuggestions
  # Syntax highlighting zsh-commands fastly
  fast_syntax_highlighting
  # Add visual vi mode (after syntax highlighting)
  vimode
  # Allow for some colour in your shell life. Ctrl-S
  emojis
  # Autopair braces etc.
  autopair
)

zplugin load willghatch/zsh-hooks


# ADDITIONAL PLUGINS TO HAVE A LOOK AT
# - zsh-manydots-magic

# Start temp. prompt quickly. Reset it when real prompt is ready
#PS1="READY > "
#zplugin ice wait'!0' atload'promptinit; prompt scala3'
#zplugin load psprint/zprompts


# CLI app for modifying setup.
#zplugin ice lucid \
#    wait'[[ -n ${ZLAST_COMMANDS[(r)cras*]} ]]'
#zplugin load zdharma/zplugin-crasis


# Color man pages
#zplugin ice svn lucid \
#    wait"0" \
#    pick"colored-man-pages.plugins.zsh" 
#zplugin snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh

for p in $ENABLED_PLUGINS[@]; do
  source "$ZDOTDIR/plugins/$p.zsh";
done

# vim: ft=zsh tw=78 et ts=2 sts=2 sw=2 cc=80
