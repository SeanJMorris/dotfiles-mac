
# On mac, .bashrc does not load by default because Mac runs every terminal
# instance as a log-in shell. Log-in shells run .bash_profile but not .bashrc,
# so this line adds .bashrc automatically when it's there

if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi
