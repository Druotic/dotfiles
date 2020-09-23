#visually breaks prompt sometimes right now
#export PS1="\[\e[48;5;237m \W \$\e[0m \]"
# hide computer name

initNvm () {
  echo "initializing nvm"
  export NVM_DIR="/usr/local/opt/nvm"
  source $NVM_DIR/nvm.sh
  source $NVM_DIR/bash_completion
  nvm use 12
}

initNvm

# Differentiate files, directories, etc
export LSCOLORS="GxfxcxdxBxegecabagacad"
alias ls='ls -lGH'

alias git-recent="git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'"
alias git-rm-remote-tag="git push --delete origin"

alias jsonFileToEscapedString="node -e \"require('assert')(process.argv[1]); const file = require(process.argv[1]); console.log(JSON.stringify(JSON.stringify(file)))\""

alias rn='react-native'
alias vim='nvim'

alias ds='docker stop -t 3 $(docker ps -aq)'
alias untgz='tar -xvzf'

alias fuckYarn="sed -i '' s/registry.yarnpkg.com/registry.npmjs.org/g"
alias commitFuckYarn="git commit -am \"s/registry.yarnpkg.com.com/registry.npmjs.org/g yarn.lock\""

# GPG signing of commits - necessary for GPG to open passphrase prompt during
# signing
export GPG_TTY="$(tty)"

unlinkPackage () {
  echo "Unlinking $1..."
  pushd ~/.config/yarn/link/$1
  ls
  yarn unlink
  popd
}

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

# Repeat command ($2) $1 times, exit early if failure
repeat-it-count-failures () {
  RE='^[0-9]+$' 
  COUNT=$1
  if ! [[ $COUNT =~ $RE ]] ; then
    echo "First arg must be a number, found '$COUNT'"
    return 1
  fi
  shift
  CMD=$@
  FAIL_COUNT=0
  echo "Executing the following command $COUNT times: '$@'"
  for i in `seq 1 $COUNT`
  do
    echo "Starting run #${i}..."
    $CMD
    if [[ $? == 1 ]]; then
      echo "Failure detected in run #${i}"
      let "FAIL_COUNT++"
    fi
  done
  echo "All done. $FAIL_COUNT/$COUNT failures detected."
}

# $1 - ag basic search pattern, $2 - sed expression
# recursively replaces file contents
superSed () {
  ag -l "$1" . | xargs sed -i '' -E "$2"
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
eval "$(rbenv init -)"

json_escape () {
    printf '%s' "$1" | node 
    printf '%s' "$1" | python -c 'import json,sys; print(json.dumps(sys.stdin.read()))'
}

port_in_use () {
  echo "Checking if port $1 is in use..."
  output=$(lsof -nP -iTCP:$1 | grep LISTEN)
  if [ "$?" == "1" ]; then
    echo "Port $1 not in use."
  else
    echo "$output"
  fi
}

### LifeOmic specific ###

reCloneLORepos () {
  rm -rf ~/repos/work/lifeomic-clone
  local key=$(security find-generic-password -l bitbucket_oauth_consumer_key -w)
  local secret=$(security find-generic-password -l bitbucket_oauth_consumer_secret -w)
  lifeomic-clone-repos -t ~/repos/work/lifeomic-clone -k $key -s $secret
}

alias cdl='cd ~/repos/work/lifeomic'
alias cdc='cd ~/repos/work/lifeomic-clone'
alias cdc2='cd ~/repos/work/lifeomic-clone-2'
alias cdp='cd ~/repos/public'
alias cdl='cd ~/repos/work/lifeomic'

wellness_deployment_dashboard () {
  lifeomic-deployment-dashboard --service << EOF \
provision-wellness-accounts \
provision-wellness-gateway \
wellness-admin-app \
wellness-configuration-service \
wellness-login \
wellness-monitor
EOF
}

mobile_deployments () {
 lifeomic-deployment-dashboard --service << EOF \
notification-service \
life-service \
social-circle-service \
file-service \
user-service \
graphql-proxy-service \
life-monitor \
life-social-queries-service \
provision-life
EOF

}
alias life-extend-device="cd ~/repos/work/lifeomic/life-extend && adb reverse tcp:8081 tcp:8081 && react-native run-android --appFolder lifeextend"
alias life-extend-device-full="cd ~/repos/work/lifeomic/life-extend/android && ./gradlew clean && cd ../ && rm -rf node_modules && yarn full-install && adb reverse tcp:8081 tcp:8081 && react-native run-android --appFolder lifeextend"

# For aws-sdk to work with configured profiles. Override AWS_PROFILE for
# per-env/role profiles (lifeomic-prod-admin, lifeomic-prod-support, etc)
# Note: privileged roles like Support require re-login w/ CLI using different
# lifeomic-master source role
export AWS_SDK_LOAD_CONFIG=true
export AWS_PROFILE=lifeomic-dev
export AWS_DEFAULT_PROFILE=lifeomic-dev
export LIFEOMIC_TARGET_ENVIRONMENT=lifeomic-dev
export AWS_REGION=us-east-1

# Mobile Stuff

export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
export BITRISEIO_ANDROID_KEYSTORE_ALIAS='e2eFakeKeystore'
export BITRISEIO_ANDROID_KEYSTORE_PRIVATE_KEY_PASSWORD='Password'
export BITRISEIO_ANDROID_KEYSTORE_PASSWORD='Password'

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

### End LifeOmic Specific ###
