
hello:
		@echo "MAKE YOUR TERMINAL GREAT AGAIN!"

zsh:
		ln -f -s $$PWD/zsh/aliases $$HOME/.aliases
		ln -f -s $$PWD/zsh/zshrc $$HOME/.zshrc


%:
		@:
