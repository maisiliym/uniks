##########################
# Coleremak Zsh vi-mode
# Details in `man zshzle(1)`
##########################
# Unbind keys - for unused maps
bindkey -ra '^R' # redo
bindkey -ra "E" # vi-forward-blank-word-end
bindkey -ra "I" # vi-insert-bol
bindkey -ra "d" # vi-delete
bindkey -ra "^L" # clear-screen
bindkey -r "^J" # accept-line # skim yank conflict
bindkey -ra "^J" # accept-line # skim yank conflict
bindkey -rv "^J" # accept-line # skim yank conflict
bindkey -ra "gE" # vi-backward-blank-word-end
bindkey -ra "gUU" # "gUgU"
bindkey -ra "gU" # vi-up-case
bindkey -ra "ga" # what-cursor-position
bindkey -ra "ge" # vi-backward-word-end
bindkey -ra "gg" # beginning-of-buffer-or-history
bindkey -ra "gu" # vi-down-case
bindkey -ra "guu" # "gugu"
bindkey -ra "g~" # vi-oper-swap-case
bindkey -ra "g~~" # "g~g~"
bindkey -r -M visual "U" # vi-up-case
bindkey -r -M visual "iW" # select-in-blank-word
bindkey -r -M visual "ia" # select-in-shell-word
bindkey -r -M visual "iw" # select-in-word
bindkey -r -M visual "j" # down-line
bindkey -r -M visual "k" # up-line
bindkey -r -M visual "o" # exchange-point-and-mark
bindkey -r -M visual "p" # put-replace-selection
bindkey -r -M visual "u" # vi-down-case

# Normal mode
bindkey -a "^S" list-choices
bindkey -a "^D" list-expand
bindkey -a "dF" vi-backward-blank-word-end
bindkey -a "df" vi-backward-word-end
bindkey -a "F" vi-forward-blank-word-end
bindkey -a "i" vi-forward-char
bindkey -a "t" vi-find-next-char
bindkey -a "g" vi-find-next-char-skip
bindkey -a "T" vi-find-prev-char
bindkey -a "G" vi-find-prev-char-skip
bindkey -a "f" vi-forward-word-end
bindkey -a "dd" beginning-of-buffer-or-history
bindkey -a "n" down-line-or-search
bindkey -a "^K" down-history
# bindkey -a ";" execute-named-cmd
# bindkey -a ":" vi-repeat-find
bindkey -a "D" vi-fetch-history
bindkey -a "k" vi-repeat-search
bindkey -a "K" vi-rev-repeat-search
bindkey -a "e" up-line-or-search
bindkey -a "^O" up-history
bindkey -a "R" vi-change-whole-line
bindkey -a "s" vi-delete
bindkey -a "dl" vi-down-case
bindkey -a "u" vi-insert
bindkey -a "U" vi-insert-bol
bindkey -a "N" vi-join
bindkey -a "S" vi-kill-eol
bindkey -a "Y" vi-open-line-above
bindkey -a "y" vi-open-line-below
bindkey -a "d~" vi-oper-swap-case
bindkey -a "O" vi-put-before
bindkey -a "o" vi-put-before
bindkey -a "P" vi-replace
bindkey -a "p" vi-replace-chars
bindkey -a "r" vi-substitute
bindkey -a "dL" vi-up-case
bindkey -a "j" vi-yank
bindkey -a "J" vi-yank-whole-line
bindkey -a "^N" accept-line
bindkey -a "^I" clear-screen
bindkey -a "l" undo
bindkey -a "^P" redo
bindkey -a "da" what-cursor-position
bindkey -a "Y" vi-digit-or-beginning-of-line

# Visual mode
bindkey -M visual "uW" select-in-blank-word
bindkey -M visual "ua" select-in-shell-word
bindkey -M visual "uw" select-in-word
bindkey -M visual "n" down-line
bindkey -M visual "e" up-line
bindkey -M visual "y" exchange-point-and-mark
bindkey -M visual "o" put-replace-selection
bindkey -M visual "l" vi-down-case
bindkey -M visual "U" vi-up-case
################
# End Coleremak
################
bindkey '^T' fzf-history-widget
bindkey '^P' fzf-cd-widget
bindkey '^F' fzf-file-widget
bindkey '^N' fzf-completion
