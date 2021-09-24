#!/bin/zsh
setopt extended_glob

ls -1 ./**/*.zsh | ack -xH "$1"
