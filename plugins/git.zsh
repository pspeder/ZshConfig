#!/bin/zsh

print - "Setting up git..."

zplugin ice wait"2" lucid as"program" pick"$ZPFX/bin/git-now" make"prefix=$ZPFX install"
zplugin load iwata/git-now
zplugin ice wait"2" lucid as"program" pick"$ZPFX/bin/git-alias" make"PREFIX=$ZPFX" nocompile
zplugin load tj/git-extras

# GitHub-like contribution graph
zplugin ice lucid \
    as"program" \
    wait'1' \
    atclone'perl Makefile.PL PREFIX=$ZPFX' \
    atpull'%atclone' \
    make'install' \
    pick"$ZPFX/bin/git-cal"
zplugin load k4rthik/git-cal

print "done"

# vim: set tw=78 ts=2 sts=2 sw=2 cc=80
