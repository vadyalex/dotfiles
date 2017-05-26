
hello:
		@printf "MAKE YOUR TERMINAL GREAT AGAIN!"


update-zsh-conf:
		ln -f -s $$PWD/zsh/aliases $$HOME/.aliases
		ln -f -s $$PWD/zsh/zshrc $$HOME/.zshrc

setup-zsh: 	update-zsh-conf
		sudo apt update
		sudo apt install zsh -y
		chsh -s /bin/zsh
		git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git $$HOME/.oh-my-zsh 

setup-tools:
		sudo apt update
		sudo apt install \
			vim \
			htop \
			tmux \
			ranger \
			-y

server-setup: setup-zsh setup-tools

desktop-setup: fresh-server-setup
		sudo apt update
		sudo apt install \
			xserver-xorg xserver-xorg-input-all \
			lightdm lightdm-gtk-greeter \
			lightdm-gtk-greeter-settings \
			i3 \
			-y

# extra executable path
setup-bin:
		ln -f -s $$PWD/bin $$HOME/.bin

update-i3-conf:
		ln -f -s $$PWD/i3/config $$HOME/.i3/config
		ln -f -s $$PWD/i3/i3status.conf $$HOME/.i3status.conf

update-X-conf:
		ln -f -s $$PWD/X/Xdefaults $$HOME/.Xdefaults

%:
		@:
