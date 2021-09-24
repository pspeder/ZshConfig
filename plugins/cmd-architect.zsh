#!/bin/zsh

# ZCA allows to copy segments of commands in history, rearrange segments of
# current command, delete segments of current command. This way user glues
# command from parts without using a mouse. Advanced history search (multi word,
# without duplicate lines) allows to quickly find the parts.
#
# Keys are:
# 
#     Ctrl-T - start Zsh Command Architect (Zshell binding)
#     Enter - delete selected segment (when in command window) or add selected segment (when in history window)
#     [ or ] - move active segment (when in command window)
#     Shift-left or Shift-right - move active segment (when in command window)
#     Tab - switch between the two available windows
#     g, G - beginning and end of the list
#     / - start incremental search
#     Esc - exit incremental search, clearing filter
#     <,>, {,} - horizontal scroll
#     Ctrl-L - redraw of whole display
#     Ctrl-O, o - enter uniq mode (no duplicate lines)
#     Ctrl-W (in incremental search) - delete whole word
#     Ctrl-K (in incremental search) - delete whole line
#     Ctrl-D, Ctrl-U - half page up or down
#     Ctrl-P, Ctrl-N - previous and next (also done with vim's j,k)
zplugin load psprint/zsh-cmd-architect

# TODO see bottom of readme if issues in tmux with underscore

# vim: ft=zsh tw=78 et ts=2 sts=2 sw=2 cc=80
