#      _               _              
#     | |__   __ _ ___| |__  _ __ ___ 
#     | '_ \ / _` / __| '_ \| '__/ __|
#     | |_) | (_| \__ \ | | | | | (__ 
#     |_.__/ \__,_|___/_| |_|_|  \___|
#                                     

# SET VARIABLES
    # Syntax highlighting for man pages using bat (a supercharged cat - see
    # https://github.com/sharkdp/bat)
export MANPAGER="bat -plman"
export HOMEBREW_CASK_OPTS="--no-quarantine"
    # option that will change default from cat to bat (this supports the `trail`
    # alias below
export NULLCMD=bat

# CREATE ALIASES
alias ll='ls -lAFh'
alias la='eza -la --header --classify --git'
alias cl='clear'
alias trail='<<<${(F)path}'
alias tree='eza --tree --level=2'
alias reload="source ~/.bashrc"
alias pjj='cd ~/Projects/'
alias lac='clear && la'
alias rm="rm -i"

mkcd() {
	mkdir -p "$1" && cd "$1"
}

cdl() {
	cd "$1" && la
}

# FUNCTION TO DRAW A LINE AND ADD SPACING TO BE ABLE TO DIFFERENTIATE COMMANDS
# AND OUTPUTS
my_precmd() {
    # Print a blank line first
    echo ""
    # Draw the horizontal line (uses printf to repeat the character)
    printf '─%.0s' $(seq 1 $COLUMNS)
    echo ""
}

# Tell Bash to run this function every time before showing the prompt
PROMPT_COMMAND=my_precmd

# Set your multi-line Bash prompt
# \w = current directory, \$ = user/root symbol, \n = newline
PS1='\w\n\$ '

# CUSTOMIZE PROMPT(S)
export PS1='bash \W $SHLVL 
\$ '

# FZF CONFIGURATIONS
export FZF_DEFAULT_OPTS="--multi --layout=reverse --border --info=inline --bind 'ctrl-/:toggle-preview' --preview 'bat --style=numbers --color=always --line-range :500 {}'"

#Source local fzf if it exists.
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Define the Homebrew prefix dynamically for macOS
if [[ $(uname -m) == "arm64" ]]; then
    BREW_PREFIX="/opt/homebrew"
else
    BREW_PREFIX="/usr/local"
fi

# Source key bindings and completion from the macOS Brew path
[ -f "$BREW_PREFIX/opt/fzf/shell/key-bindings.bash" ] && source "$BREW_PREFIX/opt/fzf/shell/key-bindings.bash"
[ -f "$BREW_PREFIX/opt/fzf/shell/completion.bash" ] && source "$BREW_PREFIX/opt/fzf/shell/completion.bash"


