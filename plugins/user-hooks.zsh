#!/bin/zsh

# Allows for creating new hooks easily
# From project readme:
# hooks-define-hook <hook_variable_name> # Defines a new hook that can be added to.
#                                        # Note that `_hook` is appended to the name!
# hooks-run-hook <hook_variable_name> # runs all functions added to the hook
# hooks-add-hook [ops] <hook_variable_name> <function> # adds function to hook
#     # options: -d to remove from hook, -D to remove with pattern
#     # everything else accepted by add-zsh-hook works... because it's the same

zplugin ice lucid wait'1'
zplugin load zsh-hooks/zsh-hooks

# vim: ft=zsh tw=78 et ts=2 sts=2 sw=2 cc=80
