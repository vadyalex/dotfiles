
.PHONY: zsh i3

hello:
		@echo "MAKE YOUR TERMINAL GREAT AGAIN!"

zsh:
		ln -f -s $$PWD/zsh/aliases $$HOME/.aliases
		ln -f -s $$PWD/zsh/zshrc $$HOME/.zshrc

i3:
		ln -f -s $$PWD/i3/config $$HOME/.i3/config
		ln -f -s $$PWD/i3/i3status.conf $$HOME/.i3status.conf

%:
		@:
