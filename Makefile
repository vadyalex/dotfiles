

hello:
	@echo ""
	@echo "         MAKE YOUR TERMINAL GREAT AGAIN!"
	@echo ""
	@echo "   \"make terminal-great-again\"          install git, oh-my-zsh, zsh, usefull system tools and sync configs"
	@echo ""
	@echo "   \"make development-machine\"           install development tools"
	@echo ""
	@echo "   \"make whale\"                         install Docker"
	@echo ""
	@echo "   \"make secrets\"                       install gopass password manager"
	@echo ""
	@echo "   \"make fresh-i3-desktop-from-scratch\" install full blown i3 desktop"
	@echo ""
	@echo "   \"make all-usefull-flatpak-apps\"      install plenty of desktop applications"
	@echo ""
	@echo "   \"make fox\"                           install latest Firefox"
	@echo ""


###############################################################################
#
#	Improve terminal expirience: install zsh, usefull tools and sync correspondent configs
#

sync-git-conf:
	        ln -f -s $$PWD/git/gitconfig $$HOME/.gitconfig

setup-git: sync-git-conf
	sudo apt update && sudo apt install -y git git-flow


sync-zsh-conf:
	@if [ ! -d "$$HOME/.bin" ]; then \
		ln -s $$PWD/bin $$HOME/.bin; \
	fi
	ln -f -s $$PWD/zsh/aliases $$HOME/.aliases
	ln -f -s $$PWD/zsh/zshrc $$HOME/.zshrc


setup-zsh: sync-zsh-conf
	sudo apt update && sudo apt install zsh -y
	chsh -s /bin/zsh
	@if [ ! -d "$$HOME/.oh-my-zsh" ]; then \
		git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git $$HOME/.oh-my-zsh; \
	fi


setup-official-backports-repo:
	echo 'deb http://ftp.debian.org/debian buster-backports main' | sudo tee /etc/apt/sources.list.d/buster-backports.list


setup-toolbelt:
	sudo apt update && sudo apt install -y \
		curl \
		rsync \
		net-tools \
		dnsutils \
		vim \
		htop \
		tmux \
		ranger caca-utils highlight atool w3m poppler-utils mediainfo \
		tree \
		speedometer \
		neofetch \
		jq \
		lolcat \
		cowsay \
		fortunes


terminal-great-again: setup-git setup-zsh setup-toolbelt

###############################################################################



###############################################################################
#
#	Install Docker
#

whale:
	# install packages to allow apt to use a repository over HTTPS
	sudo apt update && sudo apt install -y \
		curl \
		apt-transport-https \
    	ca-certificates \
    	gnupg2 \
    	software-properties-common
	# add Docker’s official GPG key
	curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
	# add Docker's official repository
	echo 'deb [arch=amd64] https://download.docker.com/linux/debian buster stable' | sudo tee /etc/apt/sources.list.d/docker.list
	# install docker!
	sudo apt update && sudo apt install -y \
		docker-ce \
		docker-ce-cli \
		containerd.io
	# add me to docker group to run docker commands without sudo
	sudo usermod -aG docker $$USER

###############################################################################



###############################################################################
#
#	Install development tools
#

setup-java: setup-toolbelt setup-official-backports-repo
	# install OpenJDK 11
	sudo apt update && sudo apt install -y \
		openjdk-11-jdk \
		openjdk-11-source

setup-clojure: setup-java
	# install latest Clojure Boot
	sudo bash -c "cd /usr/local/bin && curl -fsSLo boot https://github.com/boot-clj/boot-bin/releases/download/latest/boot.sh && chmod 755 boot"
	# install latest Leiningen
	sudo bash -c "cd /usr/local/bin && curl -fsSLo lein https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && chmod 755 lein"

setup-python: setup-toolbelt
	sudo apt update && sudo apt install -y \
		python \
		python-dev \
		python-pip
	pip install virtualenv

development-machine: setup-clojure setup-python

###############################################################################



###############################################################################
#
#	Install gopass password manager
#

secrets:
	# install packages to allow apt to use a repository over HTTPS
	sudo apt update && sudo apt install -y \
		curl \
		apt-transport-https \
    	ca-certificates \
    	gpg \
    	software-properties-common
	# add GPG key
	curl -fsSL https://api.bintray.com/orgs/gopasspw/keys/gpg/public.key | sudo apt-key add -
	# add official repository
	echo 'deb https://dl.bintray.com/gopasspw/gopass buster main' | sudo tee /etc/apt/sources.list.d/gopass.list
	# install!
	sudo apt update && sudo apt install -y gopass

###############################################################################



###############################################################################
#
#	Setup i3 wm on the fresh machine
#

sync-X-conf:
	ln -f -s $$PWD/X/Xdefaults $$HOME/.Xdefaults

setup-X: sync-X-conf
	sudo apt update && sudo apt install -y \
		xserver-xorg \
		xserver-xorg-input-all \
		xserver-xorg-input-synaptics


setup-lightdm:
	# install LightDM desktop manager
	sudo apt update && sudo apt install -y \
		lightdm \
		lightdm-gtk-greeter \
		lightdm-gtk-greeter-settings


sync-i3-conf:
	@mkdir -p $$HOME/.i3
	ln -f -s $$PWD/i3/config $$HOME/.i3/config
	ln -f -s $$PWD/i3/i3status.conf $$HOME/.i3status.conf

setup-i3: sync-i3-conf
	# install i3 window manager
	sudo apt update && sudo apt install -y i3


sync-compton-conf:
	@mkdir -p $$HOME/.config/compton
	@ln -f -s $$PWD/compton/compton.conf $$HOME/.config/compton.conf

sync-dunst-conf:
	@mkdir -p $$HOME/.config/dunst
	ln -f -s $$PWD/dunst/dunstrc $$HOME/.config/dunst/dunstrc

sync-XFCE4-terminal-conf:
	@mkdir -p $$HOME/.config/xfce4/terminal
	ln -f -s $$PWD/xfce4/terminalrc $$HOME/.config/xfce4/terminal/terminalrc

sync-rofi-conf:
	@mkdir -p $$HOME/.config/rofi
	ln -f -s $$PWD/rofi/config.rasi $$HOME/.config/rofi/config.rasi

sync-app-confs: sync-compton-conf sync-dunst-conf sync-XFCE4-terminal-conf sync-rofi-conf


sync-application-shortcuts:
	@mkdir -p $$HOME/.local/share/applications
	ln -f -s $$PWD/applications/goupdate.desktop $$HOME/.local/share/applications/goupdate.desktop
	ln -f -s $$PWD/applications/dock-at-home.desktop $$HOME/.local/share/applications/dock-at-home.desktop
	ln -f -s $$PWD/applications/dock-at-work.desktop $$HOME/.local/share/applications/dock-at-work.desktop
	ln -f -s $$PWD/applications/dock-to-present.desktop $$HOME/.local/share/applications/dock-to-present.desktop
	ln -f -s $$PWD/applications/undock.desktop $$HOME/.local/share/applications/undock.desktop
	ln -f -s $$PWD/applications/go-sync-my-projects.desktop $$HOME/.local/share/applications/go-sync-my-projects.desktop


fresh-i3-desktop-from-scratch: setup-X setup-lightdm setup-i3 sync-app-confs sync-application-shortcuts
	# install desktop tools
	sudo apt update && sudo apt install -y \
		compton \
		xfce4-terminal \
		network-manager-gnome \
		network-manager-pptp network-manager-pptp-gnome \
		vpnc network-manager-vpnc network-manager-vpnc-gnome \
		network-manager-strongswan \
		network-manager-openvpn network-manager-openvpn-gnome \
		pulseaudio \
		ttf-dejavu ttf-ancient-fonts fonts-font-awesome \
		ffmpeg \
		dunst \
		rofi \
		feh \
		hibernate \
		eog \
		xautolock \
		xbacklight \
		xclip \
		blueman \
		ibus \
		gnome-screenshot \
		nautilus \
		arandr \
		libnotify-bin \
		notify-osd \
		imagemagick \
		gnome-disk-utility
	# install Paper GTK theme, correspondend icons and cursors
	# TODO add correspondend .deb packages for paper-icon-theme,paper-gtk-theme,paper-cursor-theme
	# install tools to change GTK theme
	sudo apt install -y \
		arc-theme \
		lxappearance \
		gtk-chtheme \
		qt4-qtconfig

###############################################################################



###############################################################################
#
#	Setup Firefox Web Browser
#

define FIREFOX_DESKTOP
[Desktop Entry]
Name=Firefox
GenericName=Firefox
Exec=/usr/local/bin/firefox
Terminal=false
Icon=/opt/firefox/browser/chrome/icons/default/default48.png
Type=Application
Categories=Application;Network;X-Developer;
Comment=Firefox Web Browser
endef
export FIREFOX_DESKTOP

fox:
	@curl --silent -f -L -o '/tmp/firefox.tar.bz2' 'https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US' \
		&& sudo tar jxvf /tmp/firefox.tar.bz2 -C /opt/ \
		&& sudo ln -f -s /opt/firefox/firefox /usr/local/bin/firefox \
		&& printf "$$FIREFOX_DESKTOP" | sudo tee /usr/share/applications/firefox.desktop

###############################################################################



###############################################################################
#
#	Setup flatpak apps
#

setup-flatpak: setup-official-backports-repo
	sudo apt update && sudo apt install -y flatpak

all-usefull-flatpak-apps: setup-flatpak
	# add flathub
	sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	# install some apps!
	# communication apps..
	# Skype
	sudo flatpak install -y flathub com.skype.Client
	# Telegram
	sudo flatpak install -y flathub org.telegram.desktop
	# allow access to home directory to upload/download files for Telegram
	sudo flatpak override --filesystem=home org.telegram.desktop
	# Slack
	sudo flatpak install -y flathub com.slack.Slack	
	# Corebird Twitter client
	sudo flatpak install -y flathub org.baedert.corebird
	# media apps..
	# Spotify
	sudo flatpak install -y flathub com.spotify.Client
	# Gnome Media Player
	sudo flatpak install -y flathub io.github.GnomeMpv
	# VLC
	sudo flatpak install -y flathub org.videolan.VLC
	# office apps..
	# PDF viewer
	sudo flatpak install -y flathub org.gnome.Evince
	# LibreOffice
	sudo flatpak install -y flathub org.libreoffice.LibreOffice
	# add unofficial Firefox repo
	sudo flatpak remote-add --if-not-exists FirefoxRepo https://firefox-flatpak.mojefedora.cz/org.mozilla.FirefoxRepo.flatpakrepo
	# install Firefox Nightly
	sudo flatpak install -y FirefoxRepo org.mozilla.FirefoxNightly
	# install Firefox Developer Edition
	sudo flatpak install -y FirefoxRepo org.mozilla.FirefoxDevEdition
	# developer tools..
	# Visual Studio Code
	sudo flatpak install -y flathub com.visualstudio.code
	# Postman
	sudo flatpak install -y flathub com.getpostman.Postman

###############################################################################