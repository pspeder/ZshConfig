#!/bin/zsh
# For controlling docker and vagrant.
# From project readme:
# This plugins adds start, restart, stop, up and down commands when it detects
# a docker-compose or Vagrant file in the current directory (e.g. your
# application). Just run up and get coding! This saves you typing
# docker-compose or vagrant every time or aliasing them. Also gives you one
# set of commands that work for both environments.

zplugin ice lucid wait'4'
zplugin load Cloudstek/zsh-plugin-appup

# vim: ft=zsh tw=78 et ts=2 sts=2 sw=2 cc=80
