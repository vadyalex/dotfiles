# dotfiles

![Complete i3 desktop setup](screenshot.png?raw=true)

## Installation process

Install using curl

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/vadyalex/dotfiles/master/install.sh)"
```

or using wget

```shell
sh -c "$(wget https://raw.githubusercontent.com/vadyalex/dotfiles/master/install.sh -O -)"
```

Change to nearly cloned dotfiles directory and see the list of available commands

```shell
cd ~/.dotfiles; make
```
## Structure

### Desktop application shortcuts

Desktop application shortcuts are located under `.applications` directory each of is sym-linked into `.local/share/applications` via `make sync-desktop-applications`
