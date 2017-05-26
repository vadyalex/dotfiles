

hello:
	@printf "MAKE YOUR TERMINAL GREAT AGAIN!"


update-zsh-conf:
	@if [ ! -d "$$HOME/.bin" ]; then \
		ln -s $$PWD/bin $$HOME/.bin; \
	fi
	ln -f -s $$PWD/zsh/aliases $$HOME/.aliases
	ln -f -s $$PWD/zsh/zshrc $$HOME/.zshrc


setup-zsh: 	update-zsh-conf
	sudo apt update && sudo apt install zsh -y
	chsh -s /bin/zsh
	@if [ ! -d "$$HOME/.oh-my-zsh" ]; then \
		git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git $$HOME/.oh-my-zsh; \
	fi


setup-tools:
	sudo apt update && sudo apt install -y \
		vim \
		htop \
		tmux \
		ranger


setup-server: setup-zsh setup-tools


update-i3-conf:
	@mkdir -p $$HOME/.i3
	ln -f -s $$PWD/i3/config $$HOME/.i3/config
	ln -f -s $$PWD/i3/i3status.conf $$HOME/.i3status.conf


update-X-conf:
	ln -f -s $$PWD/X/Xdefaults $$HOME/.Xdefaults


setup-desktop: setup-server update-i3-conf update-X-conf
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
		network-manager \
		network-manager-pptp network-manager-pptp-gnome \
		network-manager-openconnect network-manager-openconnect-gnome \
		network-manager-strongswan \
		network-manager-openvpn network-manager-openvpn-gnome \
		alsa-base alsa-tools \
		pulseaudio pulseaudio-utils \
		rxvt-unicode \
		gnome-terminal \
		rofi \
		feh \
		xautolock \
		xbacklight \
		xclip \
		blueman \
		ibus \
		gnome-screenshot \
		nautilus \
		arandr \
		libnotify-bin
	# install Paper GTK theme, correspondend icons and cursors
	# TODO add correspondend .deb packages for paper-icon-theme,paper-gtk-theme,paper-cursor-theme
	# install tools to change GTK theme
	sudo apt install -y \
		arc-theme \
		lxappearance \
		gtk-chtheme \
		qt4-qtconfig

