#!/bin/bash

USERID=$(id -u)
isROOT=false
SFL="vim git tmux"
GRL="keepassx"
ILIST=""
OPT_COUNT=0
while getopts "gn" options; do
  case "${options}" in
    n)
      echo "no graphic install"
      ILIST=$SFL
      OPT_COUNT=$((OPT_COUNT+1))
      ;;
    g) 
      echo "graphical install"
      ILIST="$SFL $GRL" 
      OPT_COUNT=$((OPT_COUNT+1))
    ;;
  esac
done
echo $OPT_COUNT
if [[ "$OPT_COUNT" > "1" ]]; then
  echo "Just one option graphic install or no graphic install"
  exit 1
fi
if [[ "$OPT_COUNT" == "0" ]]; then
  ILIST=$SFL
fi
#
if [[ "$USERID" == "0" ]]; then
  isROOT=true
else
  echo "must execute as root"
  exit
fi

if [[ $isROOT == "true" ]]; then
  apt update -y && apt upgraded -y
  apt install -y $ILIST
fi  

echo "installing vundle"
mkdir -p $HOME/git/vim
git clone https://github.com/cadgo/vim.git ~/git/vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
chown -R $(whoami).$(whoami) ~/.vim
cp ~/git/vim/vimrc ~/.vimrc
cp ~/git/vim/tmux.conf ~/.tmux.conf
cp ~/git/vim/gitconfig ~/.gitconfig
