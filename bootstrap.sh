#
# This installation script is based on excelent work of Oh My Zsh project.
#

main() {
  
  # Use colors, but only if connected to a terminal, and that terminal supports them.
  if which tput >/dev/null 2>&1; then
      ncolors=$(tput colors)
  fi
  if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    BOLD="$(tput bold)"
    NORMAL="$(tput sgr0)"
  else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    NORMAL=""
  fi

  if command -v sudo > /dev/null; then
    printf "${YELLOW}sudo is already in place..${NORMAL}\n"
  else
    printf "${YELLOW}Installing sudo..\n"
    su -c "apt update && apt install sudo -y"
    printf "Complete!${NORMAL}\n"

    printf "${YELLOW}Adding $(whoami) to sudo group..\n"
    su -c "/usr/sbin/usermod -aG sudo $(whoami)"
    printf "Complete!${NORMAL}\n"

    hash sudo > /dev/null 2>&1 || {
      printf "${RED}Install sudo command to be able to run script${NORMAL}\n"
      exit 1
    }
  fi

  if command -v git > /dev/null; then
    printf "${YELLOW}git is already in place..${NORMAL}\n"
  else
    printf "${YELLOW}Installing git..\n"
    sudo apt update && sudo apt install -y git
    printf "Complete!${NORMAL}\n"
  fi

  if command -v curl > /dev/null; then
    printf "${YELLOW}curl is already in place..${NORMAL}\n"
  else
    printf "${YELLOW}Installing curl..\n"
    sudo apt update && sudo apt install -y curl
    printf "Complete!${NORMAL}\n"
  fi

  if [ ! -d ~/.dotfiles ]; then
    printf "${YELLOW}Cloning dotfiles into ~/.dotfiles..\n"
    env git clone git@github.com:vadyalex/dotfiles.git ~/.dotfiles
    printf "Complete!${NORMAL}\n"
  else
    printf "${YELLOW}dotfiles are already in place in ~/.dotfiles..${NORMAL}\n"
  fi

  if command -v bb > /dev/null; then
    printf "${YELLOW}bb is already in place..${NORMAL}\n"
  else
    printf "${YELLOW}Installing bb..\n"
    sudo bash -c "cd /tmp && curl -fsSLo bb_install https://raw.githubusercontent.com/babashka/babashka/master/install && chmod 755 bb_install && ./bb_install"
    printf "Complete!${NORMAL}\n"
  fi

  printf "\n\n"
  printf "${YELLOW}type '~/.dotfiles/bin/attune' to see the list of system states to attune to${NORMAL}"
  printf "\n"
}

main
