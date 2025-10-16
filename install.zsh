#!/usr/bin/env zsh
set -e

MARKER='myDotFileMark'
DOTFILES_DIR="$(cd $(dirname "$0") && pwd)"
START_SECS=$(date +%s)

function logd () {
  if [[ "$@" == "" ]]; then
    echo
  else
    echo "[$(date +'%H:%M:%S') $funcstack[2]] $@"
  fi
}

function update_mac_os_sys_prefs () {
  defaults write com.apple.dock mru-spaces -bool false
  defaults write com.apple.dock autohide -bool true
  killall Dock
}

function main () {
  logd "Installing..."
  setup_nodejs
  link_dot_files

  local system="$(uname)"

  set +e # temp disable, grep non-0 for no match
  uname -a | grep microsoft > /dev/null
  [[ $? -eq 0 ]] && local is_wsl=1
  set -e

  logd "uname: ${system}"
  case ${system} in
  'Darwin')
    logd "MacOS detected..."
    install_mac_os_deps
    update_mac_os_sys_prefs
    setup_kitty
    ;;
  'Linux')
    logd "Linux detected..."
    install_linux_deps
    install_vim_linux

    if [[ $is_wsl -eq 1 ]]; then
      logd "TODO. No WSL specific behavior yet..."
      # WSL installation - using Windows Terminal
    else
      # Regular linux installation - using Kitty terminal
      setup_kitty
    fi
    ;;
  *)
    logd "${system} is not supported yet"
  esac

  # Non OS-specific tools
  install_antigen

  logd "Install complete! ($(($(date +%s) - $START_SECS))s)"
}

function install_antigen () {
  logd "Installing antigen..."
  if [[ ! -f ~/.antigen.zsh ]]; then
    curl -L https://git.io/antigen > ~/.antigen.zsh
  else
    logd "antigen is already installed. Skipping."
  fi
}

function link_dot_files () {
  logd "Linking dotfiles..."

  pushd dotFiles > /dev/null
  for file in $(ls); do
    absfile="$(realpath $file)"
    basefile="$(basename $absfile)"
    logd "Linking ~/.$basefile --> $absfile"
    ln -nfs $absfile ~/.$basefile
  done
  popd > /dev/null

  pushd zsh > /dev/null
  logd ""
  logd "Appending to zsh dotfiles so that .zsh* addendums are pulled in..."

  set +e # temp disable, grep non-0 for no match
  for file in $(ls); do
    touch ~/.$file
    if ! grep -q "$MARKER" ~/.$file; then
      echo ". $(realpath $file) #$MARKER" >> ~/.$file
    fi
  done

  logd "Appending to .bash_profile to ensure env vars are loaded for bash too..."
  if ! grep -q "$MARKER" ~/.bash_profile; then
    echo ". $(realpath 'zshenv') #$MARKER" >> ~/.bash_profile
  fi
  set -e

  popd > /dev/null

  logd ""
  logd "Linking scripts"
  for file in $(ls -p ./scripts/*); do
    absfile="$(realpath $file)"
    basefile="$(basename $absfile)"
    mkdir -p $HOME/.local/bin
    logd "Linking $HOME/.local/bin/$basefile --> $absfile"
    ln -nfs $absfile "$HOME/.local/bin/$basefile"
  done

  logd ""
  logd "Linking ~/.config dirs"
  mkdir -p ~/.config
  pushd dotConfig > /dev/null
  for file in $(ls); do
    absfile="$(realpath $file)"
    basefile="$(basename $absfile)"
    logd "Linking ~/.config/$basefile --> $absfile"
    ln -nfs $absfile ~/.config/$basefile
  done
  popd > /dev/null
  logd ""
}

function update_default_shell () {
  if ! grep -q "$MARKER" ~/.bash_profile; then
    logd "Appending to .bash_profile to ensure env vars are loaded for bash too..."
    echo ". $(realpath 'zshenv') #$MARKER" >> ~/.bash_profile
  fi
}

function install_mac_os_deps() {
  logd "installing MacOS deps..."

  if [[ -f /opt/homebrew/bin/brew ]]; then
    logd "homebrew already installed. skipping"
  else 
    logd "installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
    (logd; logd 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zshenv
  fi

  logd "installing Brewfile formulas..."

  set +e
  # TODO: better handling... externally managed chrome, etc will cause non-zero exit code
  # --no-upgrade will install latest first time but allows rerunning without
  # unexpected major version bumps
  brew bundle --no-upgrade # || true
  set -e
  echo "brew bundle succeeded"
}

function install_linux_deps() {
  logd "installing linux deps..."
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
  logd 'installing Kitty...'
  if [[ ! -L ~/.local/bin/kitty ]]; then
	  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

	  # Create a symbolic link to add kitty to PATH (assuming ~/.local/bin is in
	  # your system-wide PATH)
	  ln -s ~/.local/kitty.app/bin/kitty ~/.local/bin/
	  # Place the kitty.desktop file somewhere it can be found by the OS
	  # re-enable if necessary
	  #cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
  else
	  logd "kitty already installed. skip"
  fi
}

function install_vim_linux() {
  logd "install neovim appimage..."
  if [[ ! -f ~/nvim.appimage ]]; then
	  curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
	  mv nvim.appimage $HOME
	  chmod u+x ~/nvim.appimage
  else
	  logd "neovim already installed. skip"
  fi

}

function setup_nodejs () {
  if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
  fi

  # Load NVM (this will be necessary for the current session)
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  # Install Node.js LTS version
  nvm install --lts

  # Set the installed version as the default
  nvm alias default node
}

# https://github.com/asdf-vm/asdf/issues/841#issuecomment-1636535553
function asdf_plugin_add () {
  asdf plugin add "$@" || {
	  logd "$0;$1;$2"
    local exit_code=$2

    # If asdf detects that the plugin is already installed, it prints to standard error,
    # then exits with a code of 2. We manually check this case, and return 0 so this
    # this script remains idempotent, especially when `errexit` is set.
    if ((exit_code == 2)); then
      return 0
    else
      logd "Non-zero exit code while adding plugin: $exit_code"
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

function tech_debt_reminder () {
  echo "\nWARN: reminder to revisit tech debt:"
  echo "- (9/4/23) Need to remove linux specific bits"
}

main
tech_debt_reminder
