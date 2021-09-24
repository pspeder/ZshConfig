#!/bin/zsh
setopt extended_glob

# Sourced on all shell incovations
ZSHENV_FILE=env.zsh
# Sourced on all interactive shells
ZSHRC_FILE=rc.zsh
# Sourced on login shells (before zshrc)
ZPROFILE_FILE=profile.zsh
# Sourced on login shells (after zshrc)
ZLOGIN_FILE=login.zsh
# Sourced on explicit login shell exit (exit/logout, not exec)
ZLOGOUT_FILE=logout.zsh


function _backup () {
  mv --backup=existing --suffix=.bkup \
     --strip-trailing-slashes \
     --recursive \
     "$1" "$2"
}

(( ${+BACKUP_DIR} )) || BACKUP_DIR="$HOME/Backup"

[[ -d "$ZDOTDIR" ]] || ZDOTDIR="$HOME/.zsh"
[[ -d "$ZDOTDIR" ]] && ! (empty_dir "$ZDOTDIR") && {

  mkdir -p "$BACKUP_DIR/zsh"
  _backup "$ZDOTDIR" "$BACKUP_DIR/zsh"

  [[ -L "$HOME/.zshenv" ]] \
      && rm "$HOME/.zshenv" \
      || _backup "$HOME/.zshenv" "$BACKUP_DIR/zsh/env.zsh"
}

[[ ! -d "bin" ]] && mkdir bin

# TODO Should be done for all files
setopt NULL_GLOB
for f in {$ZSHENV_FILE,$ZSHRC_FILE,$ZPROFILE_FILE,$ZLOGIN_FILE,$ZLOGOUT_FILE,utilities.zsh,./functions/**/*{,.zsh}}; do
    #cp --force \
    #   --dereference \
    #   --preserve=mode,ownership,timestamps,context,xattr -- \
    #   "$f" "bin/$fbare"
    local fbare="${f%.zsh}"
    zcompile -ca "$f" "$fbare"
    #rm $fbare
done
unsetopt NULL_GLOB

ln --force \
   --symbolic \
   --target-directory="." -- \
   bin/*.zwc
ln --force \
   --symbolic -- \
   "." "$ZDOTDIR"

# vim: ft=zsh et sw=2 sts=2 ts=2 tw=79 cc=80
