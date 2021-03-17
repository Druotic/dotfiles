# This script is for installing dotfiles. `file` will be placed in `~/.file`
set -e

DIR="$( cd "$( dirname "$(realpath $0)" )" && pwd )"

echo "Linking dotfiles"
for file in $(ls -p ./dotfiles/*); do
  # strip trailing / from dirs for linking
  absfile="$(realpath $file)"
  basefile="$(basename $absfile)"
  dirfile="$(dirname $absfile)"
  echo "Linking ~/.$basefile --> $absfile"
  ln -nfs $absfile ~/.$basefile
done

echo ""
echo "Linking scripts"
for file in $(ls -p ./scripts/*); do
  absfile="$(realpath $file)"
  basefile="$(basename $absfile)"
  dirfile="$(dirname $absfile)"
  echo "Linking $HOME/.local/bin/$basefile --> $absfile"
  ln -nfs $absfile "$HOME/.local/bin/$basefile"
done

ln -nfs "$(realpath ./other/kitty/theme.conf)" "$HOME/.config/kitty/theme.conf"
ln -nfs "$(realpath ./other/kitty/kitty.conf)" "$HOME/.config/kitty/kitty.conf"

# neovim - use shared vimrc and runtime paths
echo "Setting up init.vim to use shared vim config"
mkdir -p ~/.config/nvim
cat <<EOF > ~/.config/nvim/init.vim
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc
EOF

first_time_setup () {
  #brew bundle

  # Nvm, node lts
  #curl -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
  #source ~/.bash_profile
  #nvm install lts/*

  # vim-plug, for vim plugin loading later
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

if ! command -v ngrok 2> /dev/null; then
  first_time_setup
fi

if [ "$1" = "fast" ]; then
  echo "'fast' specified. Exiting."
  exit 0;
fi

echo "Installing nvim CoC extensions"

# Note: extensions are auto updated. However, auto update isn't support for
# in-line Plug based install via vimrc, so have to install this way :(
# Also, this hangs at the end :(
#nvim --headless -c "$(cat <<EOF
nvim -c "$(cat <<EOF
:CocInstall \
coc-tsserver \
coc-json \
coc-html \
coc-yaml \
coc-css \
coc-python \
coc-jest \
coc-tslint-plugin \
coc-eslint \
coc-docker
EOF
)"

#NVIM_PID=$?

#trap "echo \"Killed NVM PID $NVIM_PID\"" TERM

#echo "Giving Neovim :CocInstall 20 seconds to complete..."
#sleep 20
#echo ""
#echo "Killing install because it hangs indefinitely. Hopefully it finished..."
#kill $NVIM_PID
echo "Install complete."
