#      ____                        _                   _ _  ___  _              
#     |  _ \ _____      _____ _ __| |    _____   _____| / |/ _ \| | __          
#     | |_) / _ \ \ /\ / / _ \ '__| |   / _ \ \ / / _ \ | | | | | |/ /          
#     |  __/ (_) \ V  V /  __/ |  | |__|  __/\ V /  __/ | | |_| |   <           
#     |_|___\___/ \_/\_/ \___|_|  |_____\___| \_/ \___|_|_|\___/|_|\_\          
#     |_   _| |__   ___ _ __ ___   ___     / \   __| | __| (_) |_(_) ___  _ __  
#       | | | '_ \ / _ \ '_ ` _ \ / _ \   / _ \ / _` |/ _` | | __| |/ _ \| '_ \ 
#       | | | | | |  __/ | | | | |  __/  / ___ \ (_| | (_| | | |_| | (_) | | | |
#       |_| |_| |_|\___|_| |_| |_|\___| /_/   \_\__,_|\__,_|_|\__|_|\___/|_| |_|
#                                                                               
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#      ____        __             _ _              _   _   _                  
#     |  _ \  ___ / _| __ _ _   _| | |_   ___  ___| |_| |_(_)_ __   __ _ ___  
#     | | | |/ _ \ |_ / _` | | | | | __| / __|/ _ \ __| __| | '_ \ / _` / __| 
#     | |_| |  __/  _| (_| | |_| | | |_  \__ \  __/ |_| |_| | | | | (_| \__ \ 
#     |____/ \___|_|  \__,_|\__,_|_|\__| |___/\___|\__|\__|_|_| |_|\__, |___/ 
#     __      _(_) |_| |__     ___ | |__  _ __ ___  _   _ _______| |___/      
#     \ \ /\ / / | __| '_ \   / _ \| '_ \| '_ ` _ \| | | |_  / __| '_ \       
#      \ V  V /| | |_| | | | | (_) | | | | | | | | | |_| |/ /\__ \ | | |      
#       \_/\_/ |_|\__|_| |_|  \___/|_| |_|_| |_| |_|\__, /___|___/_| |_|      
#                                                   |___/                     

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# SEAN'S CHANGE: by default this section included `plugins=(git)` but I included these
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#       ____ _                 _         ____          _      
#      / ___| | __ _ _   _  __| | ___   / ___|___   __| | ___ 
#     | |   | |/ _` | | | |/ _` |/ _ \ | |   / _ \ / _` |/ _ \
#     | |___| | (_| | |_| | (_| |  __/ | |__| (_) | (_| |  __/
#      \____|_|\__,_|\__,_|\__,_|\___|  \____\___/ \__,_|\___|
#      ____       _                                           
#     / ___|  ___| |_ _   _ _ __                              
#     \___ \ / _ \ __| | | | '_ \                             
#      ___) |  __/ |_| |_| | |_) |                            
#     |____/ \___|\__|\__,_| .__/                             
#                          |_|                                

# AWS SSO authentication (okta-login)
source ~/.okta/okta-login-shell-function-nondev

# pyenv configuration
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# Add ~/.local/bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# start claude code alias
alias clo="yoda launch claude-code"

#      ____                        _                   _ _  ___  _              
#     |  _ \ _____      _____ _ __| |    _____   _____| / |/ _ \| | __          
#     | |_) / _ \ \ /\ / / _ \ '__| |   / _ \ \ / / _ \ | | | | | |/ /          
#     |  __/ (_) \ V  V /  __/ |  | |__|  __/\ V /  __/ | | |_| |   <           
#     |_|___\___/ \_/\_/ \___|_|  |_____\___| \_/ \___|_|_|\___/|_|\_\          
#     |_   _| |__   ___ _ __ ___   ___     / \   __| | __| (_) |_(_) ___  _ __  
#       | | | '_ \ / _ \ '_ ` _ \ / _ \   / _ \ / _` |/ _` | | __| |/ _ \| '_ \ 
#       | | | | | |  __/ | | | | |  __/  / ___ \ (_| | (_| | | |_| | (_) | | | |
#       |_| |_| |_|\___|_| |_| |_|\___| /_/   \_\__,_|\__,_|_|\__|_|\___/|_| |_|
#                                                                               
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#       ____            _          _    __                                    _ 
#      / ___|___  _ __ (_) ___  __| |  / _|_ __ ___  _ __ ___   __      _____| |
#     | |   / _ \| '_ \| |/ _ \/ _` | | |_| '__/ _ \| '_ ` _ \  \ \ /\ / / __| |
#     | |__| (_) | |_) | |  __/ (_| | |  _| | | (_) | | | | | |  \ V  V /\__ \ |
#      \____\___/| .__/|_|\___|\__,_| |_| |_|  \___/|_| |_| |_|   \_/\_/ |___/_|
#                |_|                                                            
# ** MOSTLY copied and pasted from WSL .zshrc**


# SET VARIABLES
# Syntax highlighting for man pages using bat (a supercharged cat - see
# https://github.com/sharkdp/bat)

# Set up `man` such that it uses bat (with better syntax highlighting)
# I set up `#export MANPAGER="bat -plman"` in my dotfiles course, but the problem with this was that 
# it wasn't reading certain characters correctly - the following change to MANPAGER corrected this
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# no quarantine overrides the "Are you sure?" message from homebrew. It's
# better to have this in for your dotfiles, but not for manual installations
    # export HOMEBREW_CASK_OPTS="--no-quarantine"
# option that will change default from cat to bat (this supports the `trail`
# alias below
    export NULLCMD=bat


# CREATE ALIASES
alias ll='ls -lAFh'
alias la='eza -la --header --classify --git'
alias cl='clear'
alias trail='<<<${(F)path}'
alias tree='eza --tree --level=2'
alias reload="source ~/.zshrc"
alias pjj='cd ~/Projects/ && la'
alias lac='clear && la'

cdl() {
	cd "$1" && la
}

mkcd() {
	mkdir -p "$1" && cd "$1"
}


# FZF CONFIGURATIONS
export FZF_DEFAULT_OPTS="--multi --layout=reverse --border --info=inline --bind 'ctrl-/:toggle-preview' --preview 'bat --style=numbers --color=always --line-range :500 {}'"

#Source local fzf if it exists.
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Define the Homebrew prefix dynamically for macOS
if [[ $(uname -m) == "arm64" ]]; then
    BREW_PREFIX="/opt/homebrew"
else
    BREW_PREFIX="/usr/local"
fi

# Source key bindings and completion from the macOS Brew path
[ -f "$BREW_PREFIX/opt/fzf/shell/key-bindings.zsh" ] && source "$BREW_PREFIX/opt/fzf/shell/key-bindings.zsh"
[ -f "$BREW_PREFIX/opt/fzf/shell/completion.zsh" ] && source "$BREW_PREFIX/opt/fzf/shell/completion.zsh"

# unalias gc which oh my zsh aliases as `git commit --verbose` 
#   this was necessary to work with google cli
unalias gc

# create new toggle so that you can switch between mouse scroll and trackpad scrolls you expect

togglescroll() {
  current=$(defaults read -g com.apple.swipescrolldirection 2>/dev/null)
  if [ "$current" = "1" ]; then
    defaults write -g com.apple.swipescrolldirection -bool false
    osascript -e 'display notification "Natural scrolling: OFF"'
  else
    defaults write -g com.apple.swipescrolldirection -bool true
    osascript -e 'display notification "Natural scrolling: ON"'
  fi
}



# togglescroll() {
#   current=$(defaults read -g com.apple.swipescrolldirection 2>/dev/null)
#   if [ "$current" = "1" ]; then
#     defaults write -g com.apple.swipescrolldirection -bool false
#   else
#     defaults write -g com.apple.swipescrolldirection -bool true
#   fi
# }


# togglescroll() {
#   current=$(defaults read -g com.apple.swipescrolldirection 2>/dev/null)
#   if [ "$current" = "1" ]; then
#     defaults write -g com.apple.swipescrolldirection -bool false
#     osascript -e 'display notification "Natural scrolling: OFF" with title "Trackpad"'
#   else
#     defaults write -g com.apple.swipescrolldirection -bool true
#     osascript -e 'display notification "Natural scrolling: ON" with title "Trackpad"'
#   fi
# }
