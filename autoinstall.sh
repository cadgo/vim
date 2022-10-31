#!/bin/bash
HOMEUSER=""
USERID=$(id -u)
isROOT=false
isGRAPHIC=false
isKALI=false
SFL="vim git tmux virtualenv"
GRL="keepassx xrdp"
ILIST=""
OPT_COUNT=0
LOGFILE="/tmp/autoinstall.log"

function setXrdp(){
   systemctl enable xrdp.service
}

function vundleInstall(){
  echo "installing vundle in $HOME directory" >> $LOGFILE
  git clone https://github.com/cadgo/vim.git ~/git/vim
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  chown -R $(whoami).$(whoami) ~/.vim
  cp ~/git/vim/vimrc ~/.vimrc
  cp ~/git/vim/tmux.conf ~/.tmux.conf
  cp ~/git/vim/gitconfig ~/.gitconfig
}
function InstallGoogleChrome(){
  echo "insttalling chrome $isGRAPHIC" >> $LOGFILE
  #insttall Chrome
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome-stable.deb
  dpkg -i /tmp/chrome-stable.deb
  apt install -f
}

function installKali(){
  KALIGUIPKG="kali-desktop-xfce xorg"
  if [[ $isROOT == "true" ]]; then
    apt install -y $KALIGUIPKG
    echo "installing Kali desktop core as root" >> $LOGFILE
  fi  
}

while getopts "kgnu:" options; do
  case "${options}" in
    u)
      HOMEUSER=$OPTARG 
    ;;
    k)
      echo "Kali Installation" > $LOGFILE
      ILIST="$SFL $GRL"
      isGRAPHIC=true
      isKALI=true
      OPT_COUNT=$((OPT_COUNT+1))
    ;;
    n)
      echo "no graphic install"
      ILIST=$SFL
      OPT_COUNT=$((OPT_COUNT+1))
      ;;
    g) 
      echo "graphical install"
      ILIST="$SFL $GRL" 
      isGRAPHIC=true
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
  if [[ $isGRAPHIC == "true" ]]; then 
    if [[ $isKALI == "true" ]]; then
      installKali
    fi
    InstallGoogleChrome
    echo $GRL | grep -w -q xrdp
    if [[ $? == 0 ]]; then
      setXrdp
    fi
  fi
  apt install -y $ILIST  
  vundleInstall 
fi


