

hello:
	@echo ""
	@echo "         MAKE YOUR TERMINAL GREAT AGAIN!"
	@echo ""
	@echo "   \"make terminal-great-again\"          install zsh, oh-my-zsh, system tools and sync configs"
	@echo ""
	@echo "   \"make setup-toolbelt\"                install system tool"
	@echo "   \"make setup-dev-toolbelt\"    	 install development tools"
	@echo ""
	@echo "   \"make setup-i3-desktop-from-scratch\" install full blown i3 desktop"
	@echo ""

########
#
#	Improve terminal expirience: install zsh, usefull tools and sync correspondent configs
#

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


setup-toolbelt:
	sudo apt update && sudo apt install -y \
		vim \
		htop \
		tmux \
		ranger caca-utils highlight atool w3m poppler-utils mediainfo \
		tree \
		speedometer \
		neofetch


sync-git-conf:
	        ln -f -s $$PWD/git/gitconfig $$HOME/.gitconfig

setup-git: sync-git-conf
	sudo apt update && sudo apt install -y git


terminal-great-again: setup-git setup-zsh setup-toolbelt


########
#
#      Install development tools
#

setup-dev-toolbelt:
	# install OpenJDK 8
	sudo apt update && sudo apt install -y openjdk-8-jdk
	# install latest Clojure Boot
	sudo bash -c "cd /usr/local/bin && curl -fsSLo boot https://github.com/boot-clj/boot-bin/releases/download/latest/boot.sh && chmod 755 boot"
	# install latest Leiningen
	sudo bash -c "cd /usr/local/bin && curl -fsSLo lein https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && chmod 755 lein"

#######
#	Setup i3 wm on the fresh machine
#

sync-i3-conf:
	@mkdir -p $$HOME/.i3
	ln -f -s $$PWD/i3/config $$HOME/.i3/config
	ln -f -s $$PWD/i3/i3status.conf $$HOME/.i3status.conf

sync-X-conf:
	ln -f -s $$PWD/X/Xdefaults $$HOME/.Xdefaults

sync-dunst-conf:
	@mkdir -p $$HOME/.config/dunst
	ln -f -s $$PWD/dunst/dunstrc $$HOME/.config/dunst/dunstrc

sync-XFCE4-terminal-conf:
	@mkdir -p $$HOME/.config/xfce4/terminal
	ln -f -s $$PWD/xfce4/terminalrc $$HOME/.config/xfce4/terminal/terminalrc

sync-desktop-applications:
	@mkdir -p $$HOME/.local/share/applications
	ln -f -s $$PWD/applications/dock-at-work.desktop $$HOME/.local/share/applications/dock-at-work.desktop
	ln -f -s $$PWD/applications/undock.desktop $$HOME/.local/share/applications/undock.desktop

sync-app-confs: sync-i3-conf sync-XFCE4-terminal-conf sync-X-conf sync-dunst-conf sync-desktop-applications


setup-i3-desktop-from-scratch: sync-app-confs
	sudo apt update
	# install X server
	sudo apt install -y \
		xserver-xorg xserver-xorg-input-all
	# install LightDM desktop manager
	sudo apt install -y \
		lightdm lightdm-gtk-greeter \
		lightdm-gtk-greeter-settings
	# install i3 window manager
	sudo apt install -y i3
	# install desktop tools
	sudo apt install -y \
		xfce4-terminal \
		xserver-xorg-input-synaptics \
		network-manager \
		network-manager-pptp network-manager-pptp-gnome \
		network-manager-openconnect network-manager-openconnect-gnome \
		network-manager-strongswan \
		network-manager-openvpn network-manager-openvpn-gnome \
		pulseaudio \
		ttf-dejavu ttf-ancient-fonts fonts-font-awesome \
		ffmpeg \
		dunst \
		rofi \
		feh \
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
		imagemagick
	# install Paper GTK theme, correspondend icons and cursors
	# TODO add correspondend .deb packages for paper-icon-theme,paper-gtk-theme,paper-cursor-theme
	# install tools to change GTK theme
	sudo apt install -y \
		arc-theme \
		lxappearance \
		gtk-chtheme \
		qt4-qtconfig


setup-desktop-apps:
	# install flatpak
	sudo add-apt-repository -y ppa:alexlarsson/flatpak
	sudo apt update && sudo apt install -y flatpak
	# add flathub
	sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	# install apps..
	# Skype
	flatpak install -y flathub com.skype.Client
	# Telegram
	flatpak install -y flathub org.telegram.desktop
	# Corebird Twitter client
	flatpak install -y flathub org.baedert.corebird
	# Spotify
	flatpak install -y flathub com.spotify.Client
	# Slack
	flatpak install -y flathub com.slack.Slack
	# Gnome Media Player
	flatpak install -y flathub io.github.GnomeMpv
	# Visual Studio Code
	flatpak install -y flathub com.visualstudio.code
	# add unofficial Firefox repo
	sudo flatpak remote-add --if-not-exists FirefoxRepo https://firefox-flatpak.mojefedora.cz/org.mozilla.FirefoxRepo.flatpakrepo
	# install Firefox Nightly
	flatpak install -y FirefoxRepo org.mozilla.FirefoxNightly
	# install Firefox Developer Edition
	flatpak install -y FirefoxRepo org.mozilla.FirefoxDevEdition
	# LibreOffice
	flatpak install -y flathub org.libreoffice.LibreOffice
