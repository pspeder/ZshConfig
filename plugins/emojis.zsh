#!/bin/zsh


# Application for selecting emoji
#export EMOJI_CLI_DICT=
export EMOJI_CLI_FILTER='fzf-tmux -d 15%:fzf:peco:percol'
#export EMOJI_CLI_KEYBIND=
#export EMOJI_CLI_USE_EMOJI
zplugin ice lucid wait'4'
zplugin load b4b4r07/emoji-cli

# '$em'_-variables containing textual emojis (kamoji?)
zplugin ice lucid wait'4'
zplugin load MichaelAquilina/zsh-emojis

# Unicode characters
zplugin ice lucid wait'4'
zplugin load zpm-zsh/figures

# vim: ft=zsh tw=78 et ts=2 sts=2 sw=2 cc=80
