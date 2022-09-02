#!/usr/bin/env bash
#
#set -e

DOTFILES_DIR="$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)"

function main () {
  echo "Installing..."

  linkDotfiles

  local SYSTEM="$(uname)"

  case ${SYSTEM} in
  'Darwin')
    echo "MacOS detected, NOT IMPLEMENTED"
    ;;
  'Linux')
    # assume Ubuntu for now
    echo "Linux detected, installing programs for Linux..."
    installLinuxPrograms
    ;;
  *)
    echo "${SYSTEM} is not supported"
  esac

  echo "Fetching antigen..."
  curl -L git.io/antigen > antigen.zsh

  setupNvm
  setupVim
  setupKitty
  setupInsync

  echo "Install complete!"
}

function linkDotfiles () {
  echo "Linking dotfiles"
  pushd dotfiles
  for file in $(ls); do
    absfile="$(realpath $file)"
    basefile="$(basename $absfile)"
    dirfile="$(dirname $absfile)"
    echo "Linking ~/.$basefile --> $absfile"
    ln -nfs $absfile ~/.$basefile
  done
  popd

  echo ""
  echo "Linking scripts"
  for file in $(ls -p ./scripts/*); do
    absfile="$(realpath $file)"
    basefile="$(basename $absfile)"
    dirfile="$(dirname $absfile)"
    mkdir -p $HOME/.local/bin
    echo "Linking $HOME/.local/bin/$basefile --> $absfile"
    ln -nfs $absfile "$HOME/.local/bin/$basefile"
  done

  ln -nfs "$(realpath ./other/kitty/theme.conf)" "$HOME/.config/kitty/theme.conf"
  ln -nfs "$(realpath ./other/kitty/kitty.conf)" "$HOME/.config/kitty/kitty.conf"
}

function installLinuxPrograms () {
  sudo apt update

  sudo apt-get install -y \
    curl \
    zsh \
    ripgrep \
    libfuse2 \
    tmux \
    pulseaudio \
    pavucontrol
  sudo snap install ngrok spotify

  sudo apt upgrade -y
}

function setupInsync () {
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ACCAF35C
  # jammy = 22.04
  echo 'deb http://apt.insync.io/ubuntu jammy non-free contrib' | sudo tee /etc/apt/sources.list.d/insync.list
  sudo apt update
  sudo apt install -y insync
}

function setupNvm () {
  echo 'installing nvm and node...'
  ## Nvm, node lts
  curl -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
  . ~/.bashrc
  nvm install lts/*
}

function setupKitty () {
  echo 'installing Kitty...'
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

  # Create a symbolic link to add kitty to PATH (assuming ~/.local/bin is in
  # your system-wide PATH)
  ln -s ~/.local/kitty.app/bin/kitty ~/.local/bin/
  # Place the kitty.desktop file somewhere it can be found by the OS
  cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
}

function setupVim () {
  # install vim plugins
  curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
  mv nvim.appimage $HOME
  chmod u+x ~/nvim.appimage

  echo "Installing vim plugged..."
  # vim
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  # neovim
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  echo "Installing vim plugins..."
  # vim +PlugInstall +PlugUpdate +qall
  ~/nvim.appimage +PlugInstall +PlugUpdate +qall
  ~/nvim.appimage +CocInstall coc-json coc-tsserver coc-html coc-python coc-jest coc-sh coc-tslint-plugin coc-eslint coc-docker +qall
}

main



























## neovim - use shared vimrc and runtime paths
#echo "Setting up init.vim to use shared vim config"
#mkdir -p ~/.config/nvim
#cat <<EOF > ~/.config/nvim/init.vim
#set runtimepath^=~/.vim runtimepath+=~/.vim/after
#let &packpath=&runtimepath
#source ~/.vimrc
#EOF

#first_time_setup () {
  ### Nvm, node lts
  #curl -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
  #. ~/.bashrc
  #nvm install lts/*

  ## vim-plug, for vim plugin loading later
  #curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    #https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  ##sudo apt-get install neovim

#}

#if ! command -v ngrok 2> /dev/null; then
  #first_time_setup
#fi

#if [ "$1" = "fast" ]; then
  #echo "'fast' specified. Exiting."
  #exit 0;
#fi

#echo "Installing nvim CoC extensions"

# Note: extensions are auto updated. However, auto update isn't support for
# in-line Plug based install via vimrc, so have to install this way :(
# Also, this hangs at the end :(
#nvim --headless -c "$(cat <<EOF
#nvim -c "$(cat <<EOF
#:CocInstall \
#coc-tsserver \
#coc-json \
#coc-html \
#coc-yaml \
#coc-css \
#coc-python \
#coc-jest \
#coc-tslint-plugin \
#coc-eslint \
#coc-docker
#EOF
#)"

#NVIM_PID=$?

#trap "echo \"Killed NVM PID $NVIM_PID\"" TERM

#echo "Giving Neovim :CocInstall 20 seconds to complete..."
#sleep 20
#echo ""
#echo "Killing install because it hangs indefinitely. Hopefully it finished..."
#kill $NVIM_PID
#main
