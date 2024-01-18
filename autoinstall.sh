#!/bin/bash
#TODO
# DETECT OPERATIVE SYSTEM AND CHECK IF IS KALI OR UBUNTU <done>
# DETECT THE USER ON THE CLI CHECK IF EXISTS IF IS NOT CREATE IT
# Fixing vundle by user, using the standard kali user by aws, validate if user exists
HOMEUSER="kali"
USERID=$(id -u)
isROOT=false
isGRAPHIC=false
isKALI=false
isDocker=false
SFL="vim git tmux virtualenv jq"
GRL="keepassx xrdp"
ILIST=""
OPT_COUNT=0
LOGFILE="/tmp/autoinstall.log"
OsVer="Ubuntu Kali"
COS=""

function setXrdp(){
   systemctl enable xrdp.service
}

function DetectOs(){
  os=$(lsb_release -d | awk '{print $2}' | tr -d [:blank:])
  if [[ "$os" == "Kali" ]]; then
    COS="Kali"
  fi
  if [[ "$os" == "Ubuntu" ]]; then
    COS="Ubuntu"
  fi
  if [[ "$COS" == "" ]]; then
    echo "Imposible to detect OS"
    exit 1
  fi
}

function InstallDocker(){
  if [[ "$COS" == "Kali" ]]; then
    printf '%s\n' "deb https://download.docker.com/linux/debian bullseye stable" | tee /etc/apt/sources.list.d/docker-ce.list
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-ce-archive-keyring.gpg
    apt update -y
    apt install -y docker-ce docker-ce-cli containerd.io docker-compose
  fi
  if [[ "$COS" == "Ubuntu" ]]; then
    apt-get install -y ca-certificates curl gnupg lsb-release
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt update -y
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose
  fi
}

function vundleInstall(){
  if id $HOMEUSER &> /dev/null; then
    echo "installing vundle in $HOMEUSER directory" >> $LOGFILE
    git clone https://github.com/cadgo/vim.git /home/$HOMEUSER/git/vim
    git clone https://github.com/VundleVim/Vundle.vim.git /home/$HOMEUSER/.vim/bundle/Vundle.vim
    chown -R $HOMEUSER.$HOMEUSER /home/$HOMEUSER/.vim
    cp /home/$HOMEUSER/git/vim/vimrc /home/$HOMEUSER/.vimrc
    cp /home/$HOMEUSER/git/vim/tmux.conf /home/$HOMEUSER/.tmux.conf
    cp /home/$HOMEUSER/git/vim/gitconfig /home/$HOMEUSER/.gitconfig
  else
    echo "User $HOMEUSER did not exists, cant install vundle"
  fi
}

function InstallGoogleChrome(){
  echo "insttalling chrome $isGRAPHIC" >> $LOGFILE
  #insttall Chrome
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome-stable.deb
  dpkg -i /tmp/chrome-stable.deb
  apt install -f
}

function installKali(){
  KALIGUIPKG="kali-desktop-xfce xorg kali-linux-large"
  if [[ $isROOT == "true" ]]; then
    apt install -y $KALIGUIPKG
    echo "installing Kali desktop core as root" >> $LOGFILE
  fi  
}
DetectOs
while getopts "dgnu:" options; do
  case "${options}" in
    d)
      echo "adding docker to the installation"
      isDocker=true 
    ;;
    u)
      HOMEUSER=$OPTARG 
    ;;
    #k)
    #  echo "Kali Installation" > $LOGFILE
    #  ILIST="$SFL $GRL"
    #  isGRAPHIC=true
    #  isKALI=true
    #  OPT_COUNT=$((OPT_COUNT+1))
    #;;
    n)
      echo "no graphic install"
      ILIST=$SFL
      OPT_COUNT=$((OPT_COUNT+1))
      ;;
    g) 
      echo "graphical install"
      if [[ "$COS" == "Kali" ]]; then
        isKALI=true
      fi
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
  if [[ $isDocker == "true" ]]; then
    InstallDocker
  fi
  vundleInstall 
fi


