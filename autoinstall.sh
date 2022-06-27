#!/bin/bash

USER=$(id -u)
isROOT=false
SFL=("vim" "tmux" "git")

if [[ "$USER" == "0" ]]; then
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
mkdir $HOME/git
git https://github.com/cadgo/vim.git ~/git
cp ~/git/vim/vimrc ~/.vimrc
cp ~/git/vim/tmux.conf ~/.tmux.conf
cp ~/git/vim/gitconfig ~/.gitconfig

