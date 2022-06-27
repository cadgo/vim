#!/bin/bash

USERID=$(id -u)
isROOT=false
SFL="vim git tmux"

if [[ "$USERID" == "0" ]]; then
  isROOT=true
else
  echo "must execute as root"
  exit
fi

if [[ $isROOT == "true" ]]; then
  apt update -y && apt upgraded -y
  apt install -y $SFL
fi  

echo "installing vundle"
mkdir -p $HOME/git/vim
git clone https://github.com/cadgo/vim.git ~/git/vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
chown -R $(whoami).$(whoami) ~/.vim
cp ~/git/vim/vimrc ~/.vimrc
cp ~/git/vim/tmux.conf ~/.tmux.conf
cp ~/git/vim/gitconfig ~/.gitconfig

