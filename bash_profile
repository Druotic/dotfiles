#visually breaks prompt sometimes right now
#export PS1="\[\e[48;5;237m \W \$\e[0m \]"
# hide computer name

initNvm () {
  echo "initializing nvm"
  export NVM_DIR="/usr/local/opt/nvm"
  source $NVM_DIR/nvm.sh
  source $NVM_DIR/bash_completion
}

alias loadnvm='loadnvm10'

# nvm environment loading
alias loadnvm8='initNvm; nvm use 8'
alias loadnvm10='initNvm; nvm use 10'

loadnvm8

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
alias cdc='cd ~/repos/lifeomic-clone'
alias cdp='cd ~/repos/public'

alias aws-dev='aws --profile lifeomic-dev'
alias aws-test='aws --profile lifeomic-test'
alias aws-infra='aws --profile lifeomic-infra'
alias aws-prod='aws --profile lifeomic-prod-us'

alias assume-admin='source ~/.config/assumeAdminDev'
alias assume-admin-infra='source ~/.config/assumeAdminInfra'
alias assume-admin-prod='source ~/.config/assumeAdminProd'
alias assume-admin-j1-dev='source ~/.config/assumeAdminJ1Dev'

alias git-recent="git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'"
alias git-rm-remote-tag="git push --delete origin"

alias jsonFileToEscapedString="node -e \"require('assert')(process.argv[1]); const file = require(process.argv[1]); console.log(JSON.stringify(JSON.stringify(file)))\""

alias rn='react-native'
#alias vim='nvim'

alias ds='docker stop -t 3 $(docker ps -aq)'
alias untgz='tar -xvzf'

alias fuckYarn="sed -i '' s/registry.yarnpkg.com/registry.npmjs.org/g"
alias commitFuckYarn="git commit -am \"s/registry.yarnpkg.com.com/registry.npmjs.org/g yarn.lock\""

alias mobile-deployments="lifeomic-deployment-dashboard --service notification-service life-service social-circle-service file-service user-service graphql-proxy-service life-monitor life-social-queries-service provision-life"

# Repeat command ($2) $1 times, exit early if failure
repeat-it () {
  RE='^[0-9]+$' 
  COUNT=$1
  if ! [[ $COUNT =~ $RE ]] ; then
    echo "First arg must be a number, found '$COUNT'"
    return 1
  fi
  shift
  echo "Executing the following command $COUNT times: '$@'"
  for i in `seq 1 $COUNT`; do $@ || return ; done
}

# $1 - ag basic search pattern, $2 - sed expression
# recursively replaces file contents
superSed () {
  ag -l "$1" . | xargs sed -i '' -E "$2"
}

reCloneLORepos () {
  #loadnvm8
  rm -rf ~/repos/lifeomic-clone
  local key=$(security find-generic-password -l bitbucket_oauth_consumer_key -w)
  local secret=$(security find-generic-password -l bitbucket_oauth_consumer_secret -w)
  lifeomic-clone-repos -t ~/repos/lifeomic-clone -k $key -s $secret
}

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

# disable per-session splitting of history, use single file
export SHELL_SESSION_HISTORY=0
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="~/.rbenv/shims:$PATH"


# Mobile Stuff

#export PATH=$PATH:/Users/druotic/.gem/ruby/2.5.0/bin
# re-enable for non-android studio route
#export ANDROID_HOME=/opt/android
#export ANDROID_HOME=/usr/local/opt/android-sdk
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
# workaround for using java 10 w/ android sdks (only supports 8 by default :()
#export JAVA_OPTS='-XX:+IgnoreUnrecognizedVMOptions --add-modules java.se.ee'

#export ANDROID_DEVICE=Pixel_2_API_28

json_escape () {
    printf '%s' "$1" | node 
    printf '%s' "$1" | python -c 'import json,sys; print(json.dumps(sys.stdin.read()))'
}
