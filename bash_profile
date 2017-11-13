# hide computer name
export PS1="\e[48;5;237m \W \$\e[0m "

# nvm environment loading
export NVM_DIR="/usr/local/opt/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# use latest LTS version of node, if nvm is installed
[ -s "$NVM_DIR/nvm.sh" ] && nvm use lts/*

# Differentiate files, directories, etc
export LSCOLORS="EHfxcxdxBxegecabagacad" 
alias ls='ls -lGH'
