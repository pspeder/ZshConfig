#!/bin/zsh

# En-/Decrypt files and directories
export PRINT_ALIAS_PREFIX='  ╰─> '
export PRINT_ALIAS_FORMAT=$'\e[1m'
export PRINT_NON_ALIAS_FORMAT=$'\e[0m'

zplugin ice lucid wait'3'
zplugin load brymck/print-alias
# vim: ft=zsh tw=78 et ts=2 sts=2 sw=2 cc=80
