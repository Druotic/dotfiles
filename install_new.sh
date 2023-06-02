#!/usr/bin/env bash
#
set -e

DOTFILES_DIR="$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)"

function main () {
  echo "Installing..."

  link_dot_files
  install_antigen

  local system="$(uname)"
  uname -a | grep microsoft > /dev/null
  [[ $? -eq 0 ]] && local is_wsl=1

  case ${system} in
  'Darwin')
    echo "MacOS detected..."
    install_mac_os_deps
    setup_kitty
    ;;
  'Linux')
    echo "Linux detected..."
    install_linux_deps
    install_vim_linux

    if [[ $is_wsl -eq 1 ]]; then
      echo "TODO. No WSL specific behavior yet..."
      # WSL installation - using Windows Terminal
    else
      # Regular linux installation - using Kitty terminal
      setup_kitty
    fi
    ;;
  *)
    echo "${system} is not supported yet"
  esac

  # Non OS-specific tools
  setup_vim

  echo "Install complete!"
}

function install_antigen () {
  echo "Installing antigen..."
  if [[ ! -f ~/.antigen.zsh ]]; then
    curl -L https://git.io/antigen > ~/.antigen.zsh
  else
    echo "antigen is already installed. Skipping."
  fi
}

function link_dot_files () {
  echo "Linking dotfiles..."

  pushd linkedDotFiles
  for file in $(ls); do
    absfile="$(realpath $file)"
    basefile="$(basename $absfile)"
    dirfile="$(dirname $absfile)"
    echo "Linking ~/.$basefile --> $absfile"
    ln -nfs $absfile ~/.$basefile
  done
  popd

  echo ""
  echo "Appending to zsh dotfiles so that extensions..."
  pushd zsh
  for file in $(ls); do
    let marker='myDotFileMark'
    if ! grep -q "$marker" ~/.$file; then
      echo ". $(realpath $file) #$marker" >> ~/.$file
    fi
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

  mkdir -p ~/.config/kitty
  echo "Linking $HOME/.config/kitty/theme.conf --> $(realpath ./other/kitty/theme.conf)"
  echo "Linking $HOME/.config/kitty/kitty.conf --> $(realpath ./other/kitty/kitty.conf)"
  ln -nfs "$(realpath ./other/kitty/theme.conf)" "$HOME/.config/kitty/theme.conf"
  ln -nfs "$(realpath ./other/kitty/kitty.conf)" "$HOME/.config/kitty/kitty.conf"
}

function install_mac_os_deps() {
  echo "installing MacOS deps..."
  brew bundle
}

function install_linux_deps() {
  echo "installing linux deps..."
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

function setup_kitty () {
  echo 'installing Kitty...'
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

  # Create a symbolic link to add kitty to PATH (assuming ~/.local/bin is in
  # your system-wide PATH)
  ln -s ~/.local/kitty.app/bin/kitty ~/.local/bin/
  # Place the kitty.desktop file somewhere it can be found by the OS
  # re-enable if necessary
  #cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
}

function install_vim_linux() {
  echo "install nvim appimage..."
  curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
  mv nvim.appimage $HOME
  chmod u+x ~/nvim.appimage
}

function setup_vim () {
  echo "Installing vim plugged..."

  # for neovim
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  echo "Installing vim plugins..."
  vim +PlugInstall +PlugUpdate +qall
  # ~/nvim.appimage +PlugInstall +PlugUpdate +qall
  # ~/nvim.appimage +CocInstall coc-json coc-tsserver coc-html coc-python coc-jest coc-sh coc-tslint-plugin coc-eslint coc-docker +qall
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
