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

  hash sudo > /dev/null 2>&1 || {
	printf "${RED}Install sudo command to be able to run script${NORMAL}\n"
	exit 1
  }

  printf "${YELLOW}Installing git and make..\n"
  sudo apt update && sudo apt install -y \
	  git \
	  make
  printf "Complete!${NORMAL}\n"

  printf "${YELLOW}Cloning dotfiles into ~/.dotfiles..\n"
  env git clone --depth=1 https://github.com/vadyalex/dotfiles.git ~/.dotfiles
  printf "Complete!${NORMAL}\n"

  cd ~/.dotfiles

  make

}

main
