# This script is for installing dotfiles. `file` will be placed in `~/.file`
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

for file in $(ls -p | grep -vE "install.sh|README.md"); do
  # strip trailing / from dirs for linking
  file="$(basename $file)"
  echo "Linking ~/.$file --> $DIR/$file"
  ln -nfs $DIR/$file ~/.$file
done
