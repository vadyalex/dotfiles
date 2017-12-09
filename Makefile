

hello:
	@printf "MAKE YOUR TERMINAL GREAT AGAIN!"


sync-zsh-conf:
	@if [ ! -d "$$HOME/.bin" ]; then \
		ln -s $$PWD/bin $$HOME/.bin; \
	fi
	ln -f -s $$PWD/zsh/aliases $$HOME/.aliases
	ln -f -s $$PWD/zsh/zshrc $$HOME/.zshrc


setup-zsh: 	sync-zsh-conf
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
		ranger


setup-server-toolbelt: setup-zsh setup-toolbelt


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

sync-conf: sync-i3-conf sync-XFCE4-terminal-conf sync-X-conf sync-dunst-conf sync-desktop-applications



setup-i3-desktop-from-scratch: setup-server-toolbelt sync-conf
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
		network-manager \
		network-manager-pptp network-manager-pptp-gnome \
		network-manager-openconnect network-manager-openconnect-gnome \
		network-manager-strongswan \
		network-manager-openvpn network-manager-openvpn-gnome \
		alsa-base alsa-tools \
		pulseaudio pulseaudio-utils \
		ttf-ancient-fonts \
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

