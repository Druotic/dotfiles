# visually breaks prompt sometimes right now
#export PS1="\[\e[48;5;237m \W \$\e[0m \]"
# hide computer name

initNvm () {
  echo "initializing nvm"
  export NVM_DIR="/usr/local/opt/nvm"
  source $NVM_DIR/nvm.sh
  source $NVM_DIR/bash_completion
}

alias loadnvm='loadnvm6'

# nvm environment loading
alias loadnvm6='initNvm; nvm use 6'

alias loadnvm8='initNvm; nvm use 8'

#source ~/.nvm/nvm.sh; source ~/.nvm/'
#export NVM_DIR="/usr/local/opt/nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# use latest LTS version of node, if nvm is installed
#[ -s "$NVM_DIR/nvm.sh" ] && nvm use lts/*

# Differentiate files, directories, etc
export LSCOLORS="GxfxcxdxBxegecabagacad"
alias ls='ls -lGH'

alias cdw='cd ~/repos/public/windbreaker-deploy/repos'
alias cdl='cd ~/repos/lifeomic'
alias cdp='cd ~/repos/public'

alias aws-dev='aws --profile lifeomic-dev'
alias aws-test='aws --profile lifeomic-test'
alias aws-infra='aws --profile lifeomic-infra'

alias assume-admin='source $(which assumeAdminDev)'

alias git-recent="git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'"

# goteem prints out the word "goteem".
#
# example:
#   $ goteem
#
#      _|_|_|     _|_|     _|_|_|_|_|   _|_|_|_|   _|_|_|_|   _|      _|
#    _|         _|    _|       _|       _|         _|         _|_|  _|_|
#    _|  _|_|   _|    _|       _|       _|_|_|     _|_|_|     _|  _|  _|
#    _|    _|   _|    _|       _|       _|         _|         _|      _|
#      _|_|_|     _|_|         _|       _|_|_|_|   _|_|_|_|   _|      _|
#
#
# be warned, if invoked, you may experience nostalgia.
goteem() {
  echo "

   _|_|_|     _|_|     _|_|_|_|_|   _|_|_|_|   _|_|_|_|   _|      _|
 _|         _|    _|       _|       _|         _|         _|_|  _|_|
 _|  _|_|   _|    _|       _|       _|_|_|     _|_|_|     _|  _|  _|
 _|    _|   _|    _|       _|       _|         _|         _|      _|
   _|_|_|     _|_|         _|       _|_|_|_|   _|_|_|_|   _|      _|

"
}

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
