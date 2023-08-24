#!/usr/bin/env bash
set -e

MARKER='myDotFileMark'
DOTFILES_DIR="$(cd $(dirname "$0") && pwd)"

function main () {
  echo "Installing..."
  link_dot_files

  local system="$(uname)"

  set +e # temp disable, grep non-0 for no match
  uname -a | grep microsoft > /dev/null
  [[ $? -eq 0 ]] && local is_wsl=1
  set -e

  echo "uname: ${system}"
  case ${system} in
  'Darwin')
    echo "MacOS detected..."
    install_mac_os_deps
    setup_kitty
    #link_brew_bash # see NOTE
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

# NOTE: not used ATM (as of 7/29/23). Something about sys dirs seems to have
# changed and made this no longer necessary. Keeping it around until next
# full reinstall just to be sure.
function link_brew_bash () {
  echo "Linking brew version of bash to ~/.local ..."
  ln -nfs "$(brew --prefix bash)/bin/bash" ~/.local/bin/bash
  sudo ln -nfs "$(brew --prefix bash)/bin/bash" "/usr/local/bin/bash"
}

function link_dot_files () {
  echo "Linking dotfiles..."

  pushd dotFiles > /dev/null
  for file in $(ls); do
    absfile="$(realpath $file)"
    basefile="$(basename $absfile)"
    echo "Linking ~/.$basefile --> $absfile"
    ln -nfs $absfile ~/.$basefile
  done
  popd > /dev/null

  pushd zsh > /dev/null
  echo ""
  echo "Appending to zsh dotfiles so that .zsh* addendums are pulled in..."

  set +e # temp disable, grep non-0 for no match
  for file in $(ls); do
    touch ~/.$file
    if ! grep -q "$MARKER" ~/.$file; then
      echo ". $(realpath $file) #$MARKER" >> ~/.$file
    fi
  done

  echo "Appending to .bash_profile to ensure env vars are loaded for bash too..."
  if ! grep -q "$MARKER" ~/.bash_profile; then
    echo ". $(realpath 'zshenv') #$MARKER" >> ~/.bash_profile
  fi
  set -e

  popd > /dev/null

  echo ""
  echo "Linking scripts"
  for file in $(ls -p ./scripts/*); do
    absfile="$(realpath $file)"
    basefile="$(basename $absfile)"
    mkdir -p $HOME/.local/bin
    echo "Linking $HOME/.local/bin/$basefile --> $absfile"
    ln -nfs $absfile "$HOME/.local/bin/$basefile"
  done

  echo ""
  echo "Linking ~/.config dirs"
  pushd dotConfig > /dev/null
  for file in $(ls); do
    absfile="$(realpath $file)"
    basefile="$(basename $absfile)"
    echo "Linking ~/.config/$basefile --> $absfile"
    ln -nfs $absfile ~/.$basefile
  done
  popd > /dev/null
  echo ""
}

function update_default_shell () {
  if ! grep -q "$MARKER" ~/.bash_profile; then
    echo "Appending to .bash_profile to ensure env vars are loaded for bash too..."
    echo ". $(realpath 'zshenv') #$MARKER" >> ~/.bash_profile
  fi
}

function install_mac_os_deps() {
  echo "installing MacOS deps..."

  if [[ -f /opt/homebrew/bin/brew ]]; then
    echo "homebrew already installed. skipping"
  else 
    echo "installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zshenv
  fi

  echo "installing Brewfile formulas..."

  # TODO: better handling... externally managed chrome, etc will cause non-zero exit code
  # --no-upgrade will install latest first time but allows rerunning without
  # unexpected major version bumps
  brew bundle --no-upgrade # || true
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

# https://github.com/asdf-vm/asdf/issues/841#issuecomment-1636535553
function asdf_plugin_add () {
  asdf plugin add "$@" || {
	  echo "$0;$1;$2"
    local exit_code=$2

    # If asdf detects that the plugin is already installed, it prints to standard error,
    # then exits with a code of 2. We manually check this case, and return 0 so this
    # this script remains idempotent, especially when `errexit` is set.
    if ((exit_code == 2)); then
      return 0
    else
      echo "Non-zero exit code while adding plugin: $exit_code"
      return $exit_code
    fi
  }
}

function setup_asdf () {
	# inspired by: https://github.com/asdf-vm/asdf/issues/240#issuecomment-811629863
	awk '{print $1 " " $NF}' ~/.tool-versions | sort \
		| comm -23 - <(asdf plugin list --urls | awk '{print $1 " " $NF}' | sort) \
		| xargs -t -L1 asdf plugin add
	asdf install
}

main
