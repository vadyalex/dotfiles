

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
	@echo "   \"make pod-dude\"                      install Podman"
	@echo ""	
	@echo "   \"make secrets\"                       install gopass password manager"
	@echo ""
	@echo "   \"make fresh-i3-desktop-from-scratch\" install full blown i3 desktop"
	@echo ""
	@echo "   \"make all-usefull-flatpak-apps\"      install plenty of desktop applications"
	@echo ""
	@echo "   \"make this-mac-usable-again\"         install development tools for macOS"
	@echo ""


define apt-install
	sudo apt update && sudo apt install -y $(1) && sudo apt autoremove -y
endef


setup-official-backports-repo:
	echo 'deb http://ftp.debian.org/debian buster-backports main' | sudo tee /etc/apt/sources.list.d/buster-backports.list


setup-apt-https:
	# install packages to allow apt to use a repository over HTTPS
	$(call apt-install, \
		curl \
		apt-transport-https \
		ca-certificates \
		gnupg2 \
		software-properties-common \
	)


###############################################################################
#
#	Improve terminal expirience: install zsh, usefull tools and sync correspondent configs
#

sync-git-conf:
	        ln -f -s $$PWD/git/gitconfig $$HOME/.gitconfig

setup-git: sync-git-conf
	$(call apt-install, git)


sync-zsh-conf:
	@if [ ! -d "$$HOME/.bin" ]; then \
		ln -s $$PWD/bin $$HOME/.bin; \
	fi
	ln -f -s $$PWD/zsh/aliases $$HOME/.aliases
	ln -f -s $$PWD/zsh/zshrc $$HOME/.zshrc


setup-zsh: sync-zsh-conf
	$(call apt-install, zsh)
	chsh -s /bin/zsh
	@if [ ! -d "$$HOME/.oh-my-zsh" ]; then \
		git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git $$HOME/.oh-my-zsh; \
	fi


setup-toolbelt:
	$(call apt-install, \
		curl wget \
		rsync \
		mosh \
		net-tools iperf3 dnsutils \
		smartmontools \
		neovim \
		htop \
		tmux \
		ranger caca-utils highlight atool w3m poppler-utils mediainfo \
		chafa \
		tree \
		speedometer \
		neofetch \
		jq miller \
		lolcat cowsay sl figlet cmatrix \
		borgbackup restic \
	)


terminal-great-again: setup-git setup-zsh setup-toolbelt

###############################################################################



###############################################################################
#
#	Install Docker
#

whale: setup-apt-https
	# add Docker’s official GPG key
	curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
	# add Docker's official repository
	echo 'deb [arch=amd64] https://download.docker.com/linux/debian buster stable' | sudo tee /etc/apt/sources.list.d/docker.list
	# install docker!
	$(call apt-install, docker-ce docker-ce-cli containerd.io)
	# add me to docker group to run docker commands without sudo
	sudo usermod -aG docker $$USER

###############################################################################



###############################################################################
#
#	Install Podman
#

pod-dude: setup-apt-https
	# add Podman’s official GPG key for Debian 10
	curl -fsSL https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/Debian_10/Release.key | sudo apt-key add -
	# add Podman's official repository for Debian 10
	echo 'deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_10/ /' | sudo tee /etc/apt/sources.list.d/podman.list
	# install Podman!
	$(call apt-install, podman)
	# enable user namespace support (more info available here https://github.com/containers/libpod/issues/3207)
	sudo sysctl -w kernel.unprivileged_userns_clone=1
	echo 'kernel.unprivileged_userns_clone=1' | sudo tee /etc/sysctl.d/userns.conf

###############################################################################



###############################################################################
#
#	Install development tools
#

setup-java: setup-toolbelt setup-official-backports-repo
	# install OpenJDK 11
	$(call apt-install, \
		openjdk-11-jdk \
		openjdk-11-source \
	)


setup-clojure: setup-java
	# install latest Clojure Boot
	sudo bash -c "cd /usr/local/bin && curl -fsSLo boot https://github.com/boot-clj/boot-bin/releases/download/latest/boot.sh && chmod 755 boot"
	# install latest Leiningen
	sudo bash -c "cd /usr/local/bin && curl -fsSLo lein https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && chmod 755 lein"


setup-python: setup-toolbelt
	$(call apt-install, \
		python \
		python-dev \
		python-pip \
	)
	pip install virtualenv


setup-js: setup-toolbelt
	export NVM_DIR="$$HOME/.nvm" && ( \
		git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR" \
		cd "$NVM_DIR" \
		git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)` \
	) && \. "$NVM_DIR/nvm.sh"
	nvm install node


development-machine: setup-clojure setup-python

###############################################################################



###############################################################################
#
#	Install gopass password manager
#

secrets: setup-apt-https
	# add GPG key
	curl -fsSL https://api.bintray.com/orgs/gopasspw/keys/gpg/public.key | sudo apt-key add -
	# add official repository
	echo 'deb https://dl.bintray.com/gopasspw/gopass buster main' | sudo tee /etc/apt/sources.list.d/gopass.list
	# install!
	$(call apt-install, gopass)

###############################################################################



###############################################################################
#
#	Setup i3 wm on the fresh machine
#

sync-X-conf:
	ln -f -s $$PWD/X/Xdefaults $$HOME/.Xdefaults

setup-X: sync-X-conf
	$(call apt-install, \
		xserver-xorg \
		xserver-xorg-input-all \
		xserver-xorg-input-synaptics \
	)


setup-lightdm:
	# install LightDM desktop manager
	$(call apt-install, \
		lightdm \
		lightdm-gtk-greeter \
		lightdm-gtk-greeter-settings \
	)


sync-i3-conf:
	@mkdir -p $$HOME/.i3
	ln -f -s $$PWD/i3/config $$HOME/.i3/config
	ln -f -s $$PWD/i3/i3status.conf $$HOME/.i3status.conf

setup-i3: sync-i3-conf
	# install i3 window manager
	$(call apt-install, i3)


setup-fonts:
	# download and install Nerd Fonts system wide
	$(call apt-install, fontconfig) && \
	bash -c "cd /tmp && curl -fsSLo nerd_fonts_archive.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" && \
	sudo bash -c "cd /tmp && unzip -o nerd_fonts_archive.zip -d /usr/share/fonts" && \
	sudo fc-cache -f -v


sync-alacritty-conf:
	@mkdir -p $$HOME/.config/alacritty
	ln -f -s $$PWD/alacritty/alacritty.yml $$HOME/.config/alacritty/alacritty.yml

setup-alacritty: sync-alacritty-conf
	# install runtime dependency
	$(call apt-install, cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3)
	# copy binary
	sudo cp $$PWD/alacritty/alacritty /usr/bin/alacritty
	# copy desktop shortcut to launch via rofi
	sudo cp $$PWD/alacritty/alacritty.desktop /usr/share/applications/alacritty.desktop


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
	$(foreach file, $(wildcard $(PWD)/applications/*.desktop), ln -f -s $(file) $$HOME/.local/share/applications/$(notdir $(file));)


fresh-i3-desktop-from-scratch: setup-X setup-lightdm setup-i3 setup-fonts sync-app-confs sync-application-shortcuts setup-alacritty
	# install desktop tools
	$(call apt-install, \
		compton \
		xfce4-terminal \
		network-manager-gnome \
		network-manager-pptp network-manager-pptp-gnome \
		vpnc network-manager-vpnc network-manager-vpnc-gnome \
		network-manager-strongswan \
		network-manager-openvpn network-manager-openvpn-gnome \
		pulseaudio \
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
		gvfs-fuse \
		arandr \
		libnotify-bin \
		notify-osd \
		imagemagick \
		gnome-disk-utility \
	)
	# install Paper GTK theme, correspondend icons and cursors
	# TODO add correspondend .deb packages for paper-icon-theme,paper-gtk-theme,paper-cursor-theme
	# install tools to change GTK theme
	$(call apt-install, \
		arc-theme \
		lxappearance \
		gtk-chtheme \
		qt4-qtconfig \
	)


###############################################################################



###############################################################################
#
#	Setup flatpak apps
#

setup-flatpak:
	$(call apt-install, flatpak)
	# add flathub
	sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo


define flathub-install
	sudo flatpak install -y flathub $(1);
endef


define flathub-install-many
	$(foreach app, $(1), $(call flathub-install, $(app)))
endef


all-usefull-flatpak-apps: setup-flatpak
	# install some apps!
	# Firefox!
	$(call flathub-install, org.mozilla.firefox)
	# allow access to home directory to download files for Firefox
	sudo flatpak override --filesystem=home org.mozilla.firefox
	# communication apps..
	# Skype
	$(call flathub-install, com.skype.Client)
	# allow access to home directory to upload/download files for Telegram
	sudo flatpak override --filesystem=home com.skype.Client
	# Telegram
	$(call flathub-install, org.telegram.desktop)
	# allow access to home directory to upload/download files for Telegram
	sudo flatpak override --filesystem=home org.telegram.desktop
	# Slack
	$(call flathub-install, com.slack.Slack)
	# media apps..
	# Spotify
	$(call flathub-install, com.spotify.Client)
	# VLC
	$(call flathub-install, org.videolan.VLC)
	# Transmission
	$(call flathub-install, com.transmissionbt.Transmission)
	# office apps..
	# PDF viewer
	$(call flathub-install, org.gnome.Evince)
	# LibreOffice
	$(call flathub-install, org.libreoffice.LibreOffice)
	# Beautiful markdown editor
	$(call flathub-install, org.gnome.gitlab.somas.Apostrophe)
	# developer tools..
	# Visual Studio Code
	$(call flathub-install, com.visualstudio.code)
	# CAD soft to design for 3D printer
	# FreeCAD very similar to AutoCAD
	$(call flathub-install, org.freecadweb.FreeCAD)
	# OpenSCAD for declarative design
	$(call flathub-install, org.openscad.OpenSCAD)
	# PrusaSlicer!
	$(call flathub-install, com.prusa3d.PrusaSlicer)
###############################################################################



###############################################################################
#
#	All things Mac
#

setup-brew:
	brew || (curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh 	\
			 &&									\
			 sudo chown -R $(whoami) /usr/local/share/zsh)


define brew-install
	brew list $(1) 2>/dev/null || brew install $(1);
endef


define brew-install-many
	$(foreach formula, $(1), $(call brew-install, $(formula)))
endef


setup-mac-toolbelt:
	$(call brew-install-many, \
		htop \
		tmux \
		ranger \
		tree \
		neofetch \
		jq miller \
		lolcat \
		cowsay \
		restic \
		tree \
	)


setup-mac-openjdk:
	$(call brew-install, openjdk)
	echo "Creating systemwide symlink pointing to OpenJDK.."
	sudo ln -sfn $(brew --prefix)/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk


setup-mac-devops-toolbelt:
	$(call brew-install-many, \
		openshift-cli \
		ansible helm \
	)

setup-mac-alacritty: sync-alacritty-conf
	$(call brew-install, alacritty)
	

this-mac-usable-again: setup-mac-toolbelt setup-mac-openjdk setup-mac-devops-toolbelt setup-mac-alacritty

###############################################################################
