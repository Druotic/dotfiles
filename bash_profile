# hide computer name
export PS1="\W \$"

# nvm environment loading
export NVM_DIR="/usr/local/opt/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# use latest LTS version of node
nvm use lts/*

export LSCOLORS="EHfxcxdxBxegecabagacad" 
alias ls='ls -lGH'
