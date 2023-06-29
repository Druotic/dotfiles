#!/usr/bin/env bash
#
#set -e

DOTFILES_DIR="$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)"

function main () {
  echo "Installing..."
  link_dot_files

  local system="$(uname)"
  uname -a | grep microsoft
  uname -a | grep microsoft > /dev/null
  [[ $? -eq 0 ]] && local is_wsl=1

  echo "uname: ${system}"
  case ${system} in
  'Darwin')
    echo "MacOS detected..."
    install_mac_os_deps
    setup_kitty
    link_brew_bash
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
  install_antigen
  setup_asdf
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

function link_brew_bash () {
  echo "Linking brew version of bash to ~/.local ..."
  #ln -nfs "$(brew --prefix bash)/bin/bash" ~/.local/bin/bash
  sudo ln -nfs "$(brew --prefix bash)/bin/bash" "/usr/local/bin/bash"
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

  pushd zsh
  echo ""
  echo "Appending to zsh dotfiles so that .zsh* addendums are pulled in..."
  let marker='myDotFileMark'
  for file in $(ls); do
    if ! grep -q "$marker" ~/.$file; then
      echo ". $(realpath $file) #$marker" >> ~/.$file
    fi
  done
  if ! grep -q "$marker" ~/.bash_profile; then
    echo "Appending to .bash_profile to ensure env vars are loaded for bash too..."
    echo ". $(realpath 'zshenv') #$marker" >> ~/.bash_profile
  fi
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

function update_default_shell () {

  let marker='myDotFileMark'
  if ! grep -q "$marker" ~/.bash_profile; then
    echo "Appending to .bash_profile to ensure env vars are loaded for bash too..."
    echo ". $(realpath 'zshenv') #$marker" >> ~/.bash_profile
  fi
}

function install_mac_os_deps() {
  echo "installing MacOS deps..."
  # TODO: better handling... externally managed chrome, etc will cause non-zero exit code
  # --no-upgrade will install latest first time but allows rerunning without
  # unexpected major version bumps
  brew bundle --no-upgrade || true
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
  if [[ ! -L ~/.local/bin/kitty ]]; then
	  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

	  # Create a symbolic link to add kitty to PATH (assuming ~/.local/bin is in
	  # your system-wide PATH)
	  ln -s ~/.local/kitty.app/bin/kitty ~/.local/bin/
	  # Place the kitty.desktop file somewhere it can be found by the OS
	  # re-enable if necessary
	  #cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
  else
	  echo "kitty already installed. skip"
  fi
}

function install_vim_linux() {
  echo "install neovim appimage..."
  if [[ ! -f ~/nvim.appimage ]]; then
	  curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
	  mv nvim.appimage $HOME
	  chmod u+x ~/nvim.appimage
  else
	  echo "neovim already installed. skip"
  fi

}

function setup_vim () {
  echo "Setting up neovim..."
  if [[ -f ~/.local/share/nvim/site/autoload/plug.vim ]]; then
	  echo "vim already set up. skip"
	  return 0
  fi

  # for neovim
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  echo "Installing vim plugins..."
  #nvim --headless +PlugInstall +PlugUpdate +qall
  #nvim +PlugInstall +PlugUpdate +qall
  #nvim +CocInstall coc-json coc-tsserver coc-html coc-python coc-jest coc-sh coc-tslint-plugin coc-eslint coc-docker +qall

  # neovim - use shared vimrc and runtime paths
  echo "Setting up init.vim to use shared vim config"
  mkdir -p ~/.config/nvim
  cat <<EOF > ~/.config/nvim/init.vim
  set runtimepath^=~/.vim runtimepath+=~/.vim/after
  let &packpath=&runtimepath
  source ~/.vimrc
EOF
}

function setup_asdf () {
  asdf plugin add nodejs
  asdf plugin add yarn
  asdf plugin add python
  asdf plugin add terraform
  asdf plugin add go
}

main


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
