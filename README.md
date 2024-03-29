# dotfiles

![Complete i3 desktop setup](screenshot.png?raw=true)

## Installation process

Install using curl

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/vadyalex/dotfiles/master/bootstrap.sh)"
```

or using wget

```shell
sh -c "$(wget https://raw.githubusercontent.com/vadyalex/dotfiles/master/bootstrap.sh -O -)"
```

Change to nearly cloned dotfiles directory and see the list of available commands

```shell
cd ~/.dotfiles/bin; ./attune
```

## Theming

Update theme and background of the login screen

```shell
sudo lightdm-gtk-greeter-settings
```

Update theme across all graphical interface frameworks via

```shell
lxappearance
```

```shell
gtk-chtheme
```

and finally make Qt use GTK+ theme in the dropdown menu via

```shell
qtconfig-qt4
```

## Structure

### Desktop application shortcuts

Desktop application shortcuts are located under `.applications` directory each of is sym-linked into `.local/share/applications` via `make sync-desktop-applications`
