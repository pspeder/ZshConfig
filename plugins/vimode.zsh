#!/bin/zsh
bindkey -v

zplugin ice lucid wait"2" # should load after zsh-fast-syntax-highlighting
zplugin load softmoth/zsh-vim-mode

MODE_INDICATOR_VIINS='%F{15}<%F{8}INSERT<%f'
MODE_INDICATOR_VICMD='%F{10}<%F{2}NORMAL<%f'
MODE_INDICATOR_REPLACE='%F{9}<%F{1}REPLACE<%f'
MODE_INDICATOR_SEARCH='%F{13}<%F{5}SEARCH<%f'
MODE_INDICATOR_VISUAL='%F{12}<%F{4}VISUAL<%f'
MODE_INDICATOR_VLINE='%F{12}<%F{4}V-LINE<%f'

#bindkey -N vivis

## Key configuration
#bindkey -M vicmd 'V'  vi-vlines-mode
#bindkey -M vicmd 'v'  vi-visual-mode
#bindkey -M vivis ' '  vi-visual-forward-char
#bindkey -M vivis ','  vi-visual-rev-repeat-find
#bindkey -M vivis '0'  vi-visual-bol
#bindkey -M vivis ';'  vi-visual-repeat-find
#bindkey -M vivis 'B'  vi-visual-backward-blank-word
#bindkey -M vivis 'C'  vi-visual-substitute-lines
#bindkey -M vivis 'D'  vi-visual-kill-and-vicmd
#bindkey -M vivis 'E'  vi-visual-forward-blank-word-end
#bindkey -M vivis 'F'  vi-visual-find-prev-char
#bindkey -M vivis 'G'  vi-visual-goto-line
#bindkey -M vivis 'I'  vi-visual-insert-bol
#bindkey -M vivis 'J'  vi-visual-join
#bindkey -M vivis 'O'  vi-visual-exchange-points
#bindkey -M vivis 'R'  vi-visual-substitute-lines
#bindkey -M vivis 'S ' vi-visual-surround-space
#bindkey -M vivis "S'" vi-visual-surround-squote
#bindkey -M vivis 'S"' vi-visual-surround-dquote
#bindkey -M vivis 'S(' vi-visual-surround-parenthesis
#bindkey -M vivis 'S)' vi-visual-surround-parenthesis
#bindkey -M vivis 'T'  vi-visual-find-prev-char-skip
#bindkey -M vivis 'U'  vi-visual-uppercase-region
#bindkey -M vivis 'V'  vi-visual-exit-to-vlines
#bindkey -M vivis 'W'  vi-visual-forward-blank-word
#bindkey -M vivis 'Y'  vi-visual-yank
#bindkey -M vivis '^M' vi-visual-yank
#bindkey -M vivis '^[' vi-visual-exit
#bindkey -M vivis 'b'  vi-visual-backward-word
#bindkey -M vivis 'c'  vi-visual-change
#bindkey -M vivis 'd'  vi-visual-kill-and-vicmd
#bindkey -M vivis 'e'  vi-visual-forward-word-end
#bindkey -M vivis 'f'  vi-visual-find-next-char
#bindkey -M vivis 'gg' vi-visual-goto-first-line
#bindkey -M vivis 'h'  vi-visual-backward-char
#bindkey -M vivis 'j'  vi-visual-down-line
#bindkey -M vivis 'jj' vi-visual-exit
#bindkey -M vivis 'k'  vi-visual-up-line
#bindkey -M vivis 'l'  vi-visual-forward-char
#bindkey -M vivis 'o'  vi-visual-exchange-points
#bindkey -M vivis 'p'  vi-visual-put
#bindkey -M vivis 'r'  vi-visual-replace-region
#bindkey -M vivis 't'  vi-visual-find-next-char-skip
#bindkey -M vivis 'u'  vi-visual-lowercase-region
#bindkey -M vivis 'v'  vi-visual-eol
#bindkey -M vivis 'w'  vi-visual-forward-word
#bindkey -M vivis 'y'  vi-visual-yank
#
#zplugin ice lucid wait"3" # should load after zsh-fast-syntax-highlighting
#zplugin load b4b4r07/zsh-vimode-visual

# vim: ft=zsh tw=78 et ts=2 sts=2 sw=2 cc=80
