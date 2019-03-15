# This script is intended to be run on initial installation, loading basics needed
# to install vim plugins, node env, etc.

# WARNING: Do not run after initial setup is complete

# Run install.sh for dotfiles first! Necessary for nvm to work

set -e

# Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# shiftit - windowing
brew cask install shiftit
brew cask install google-chrome
brew install gawk
brew install the_silver_searcher

# Nvm, node lts
curl -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
source ~/.bash_profile
nvm install lts/*

# vim-plug, for vim plugin loading later
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


