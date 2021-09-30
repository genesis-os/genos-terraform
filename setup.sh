#!/usr/bin/env bash
#
# SPDX-License-Identifier: GPL-3.0-or-later

## Pre-build script for archcraft OS.

## ANSI Colors (FG & BG)
RED="$(printf '\033[31m')"  GREEN="$(printf '\033[32m')"  ORANGE="$(printf '\033[33m')"  BLUE="$(printf '\033[34m')"
MAGENTA="$(printf '\033[35m')"  CYAN="$(printf '\033[36m')"  WHITE="$(printf '\033[37m')" BLACK="$(printf '\033[30m')"
REDBG="$(printf '\033[41m')"  GREENBG="$(printf '\033[42m')"  ORANGEBG="$(printf '\033[43m')"  BLUEBG="$(printf '\033[44m')"
MAGENTABG="$(printf '\033[45m')"  CYANBG="$(printf '\033[46m')"  WHITEBG="$(printf '\033[47m')" BLACKBG="$(printf '\033[40m')"

## Directories
DIR="$(pwd)"

## Build mode
BUILD_MODE=$1

## Banner
banner () {
        banner_b64="CgoJIOKWiOKWiOKWiOKWiOKWiOKWiOKVlyDilojilojilojilojilojilojilojilZfilojilojilojilZcgICDilojilojilZcg4paI4paI4paI4paI4paI4paI4pWXIOKWiOKWiOKWiOKWiOKWiOKWiOKWiOKVlwoJ4paI4paI4pWU4pWQ4pWQ4pWQ4pWQ4pWdIOKWiOKWiOKVlOKVkOKVkOKVkOKVkOKVneKWiOKWiOKWiOKWiOKVlyAg4paI4paI4pWR4paI4paI4pWU4pWQ4pWQ4pWQ4paI4paI4pWX4paI4paI4pWU4pWQ4pWQ4pWQ4pWQ4pWdCgnilojilojilZEgIOKWiOKWiOKWiOKVl+KWiOKWiOKWiOKWiOKWiOKVlyAg4paI4paI4pWU4paI4paI4pWXIOKWiOKWiOKVkeKWiOKWiOKVkSAgIOKWiOKWiOKVkeKWiOKWiOKWiOKWiOKWiOKWiOKWiOKVlwoJ4paI4paI4pWRICAg4paI4paI4pWR4paI4paI4pWU4pWQ4pWQ4pWdICDilojilojilZHilZrilojilojilZfilojilojilZHilojilojilZEgICDilojilojilZHilZrilZDilZDilZDilZDilojilojilZEKCeKVmuKWiOKWiOKWiOKWiOKWiOKWiOKVlOKVneKWiOKWiOKWiOKWiOKWiOKWiOKWiOKVl+KWiOKWiOKVkSDilZrilojilojilojilojilZHilZrilojilojilojilojilojilojilZTilZ3ilojilojilojilojilojilojilojilZEKCeKVmuKVkOKVkOKVkOKVkOKVkOKVnSDilZrilZDilZDilZDilZDilZDilZDilZ3ilZrilZDilZ0gIOKVmuKVkOKVkOKVkOKVnSDilZrilZDilZDilZDilZDilZDilZ0g4pWa4pWQ4pWQ4pWQ4pWQ4pWQ4pWQ4pWdCi0uXyAgICBfLi0tJyJgJy0tLl8gICAgXy4tLSciYCctLS5fICAgIF8uLS0nImAnLS0uXyAgICBfICAgCiAgICAnLTpgLid8YHwiJzotLiAgJy06YC4nfGB8Iic6LS4gICctOmAuJ3xgfCInOi0uICAnLmAgOiAnLiAgIAogICcuICAnLiAgfCB8ICB8IHwnLiAgJy4gIHwgfCAgfCB8Jy4gICcuICB8IHwgIHwgfCcuICAnLjogICAnLiAgJy4KICA6ICcuICAnLnwgfCAgfCB8ICAnLiAgJy58IHwgIHwgfCAgJy4gICcufCB8ICB8IHwgICcuICAnLiAgOiAnLiAgYC4KICAnICAgJy4gIGAuOl8gfCA6Xy4nICcuICBgLjpfIHwgOl8uJyAnLiAgYC46XyB8IDpfLicgJy4gIGAuJyAgIGAuCiAgICAgICAgIGAtLi4sLi4tJyAgICAgICBgLS4uLC4uLScgICAgICAgYC0uLiwuLi0nICAgICAgIGAgICAgICAgICBgCg=="
    clear
    cat <<- _EOF_
                ${RED}          
                `echo $banner_b64|base64 -d`
										
			${ORANGE}[*] ${CYAN}By: Ege BALCI
			${ORANGE}[*] ${CYAN}Github: @egebalci
			${ORANGE}[*] ${CYAN}Twitter: @egeblc
_EOF_

}

## Reset terminal colors
reset_color() {
	tput sgr0   # reset attributes
	tput op     # reset color
    return
}

print_status() {
	echo -n ${ORANGE}"[*] "
	reset_color
	echo $1  
}

print_error() {
	echo -n ${RED}"[-] "
	reset_color
	echo $1
}

print_fatal() {
	echo -e ${RED}"\n[!] $1\n"
	reset_color
	exit
}


print_good() {
	echo -n ${GREEN}"[+] "
	reset_color
	echo $1
}

## Script Termination
exit_on_signal_SIGINT () {
    print_fatal "Script interrupted."
    exit 0
}

exit_on_signal_SIGTERM () {
    print_fatal "Script terminated."
    exit 0
}

trap exit_on_signal_SIGINT SIGINT
trap exit_on_signal_SIGTERM SIGTERM

must_exist() {
	if [ ! -f "`which $1`" ]; then
		print_error "$1 not installed!"
		exit 1
	fi
}


## Enable multilib
enable_multilib() {
	print_status "Enabling multilib on pacman..."
	sed -i 's|#\[multilib\]|\[multilib\]|g' /etc/pacman.conf
	sed -i 's|#Include = /etc/pacman\.d/mirrorlist|Include = /etc/pacman\.d/mirrorlist|g' /etc/pacman.conf
	sudo pacman -Syy
}

## Prerequisite
install_pacman_packages() {
	print_status "We need to clear pacman cache, !!! please remove all cache files !!!"
	echo -e "\n"
	sudo pacman -Scc
	echo -e "\n"
	print_status "Updating pacman..."
	sudo pacman -Syy
	print_status "Installing pacman packages..."

	while IFS='' read -r line || [[ -n "$line" ]]; do
		sudo pacman --noconfirm -S  $line
	done < <(grep -v "#" packages.txt | grep -E "^." | sort -u)
}

install_git_packages(){
	must_exist "zsh"
	must_exist "git"

	print_status "Installing latest oh-my-zsh..."
	git clone --depth=1 --branch master https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh" >>/tmp/.terraform.log 2>&1
	print_status "Installing latest powerlevel10k..."
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" >>/tmp/.terraform.log 2>&1
	print_status "Installing vundle..."
	git clone https://github.com/VundleVim/Vundle.vim.git "$HOME/.vim/bundle/Vundle.vim" >>/tmp/.terraform.log 2>&1
}


install_yay_packages() {
	must_exist "git"

	print_status "Building yay..."
	git clone https://aur.archlinux.org/yay-git.git /tmp/yay
	if [ ! -d /tmp/yay ]; then
		print_error "Failed to clone yay!"
		exit 1
	fi

	cd /tmp/yay
	makepkg -si --noconfirm >>/tmp/.terraform.log 2>&1
	cd $DIR
	yay -Syu

	print_status "Installing AUR packages..."
	# yay_packages=("polybar" "networkmanager-dmenu" "opensnitch-git" "plymouth" "i3lock-color" "blight" "mkinitcpio-openswap" "ckbcomp")
	# for package in "${yay_packages[@]}";
	# do
	# 	yay -S $package 
	# done

	while IFS='' read -r line || [[ -n "$line" ]]; do
		yay --noconfirm -S  $line
	done < <(grep -v "#" aur_packages.txt | grep -E "^." | sort -u)
}

install_dotfiles() {
	must_exist "git"
	must_exist "vim"

	print_status "Installing dotfiles..."
	git clone --recurse-submodules https://github.com/egebalci/dotfiles /tmp/dotfiles >>/tmp/.terraform.log 2>&1
	rm -rf /tmp/dotfiles/.git/
	find /tmp/dotfiles/ -name ".*" -exec mv -t $HOME "{}"
	rm -rf /tmp/dotfiles/
	print_status "Switching default shell to zsh..."
	chsh -s `which zsh`
	xrdb $HOME/.Xresources
	print_status "Piping shell history to /dev/null..."
	ln -s /dev/null $HOME/.zsh_history
	ln -s /dev/null $HOME/.bash_history
	print_status "Installing vundle plugins..."
	vim +PluginInstall +qall
}

install_fonts() {
	print_status "Installing fonts..."
	sudo find ./fonts/ -type f -exec sudo install -Dm 644 "{}" "/usr/share/fonts/{}" \; >>/tmp/.terraform.log 2>&1
	sudo fc-cache -f >>/tmp/.terraform.log 2>&1 
}

install_icons() {
	print_status "Installing icons..."
	sudo mkdir -p /usr/share/icons
	sudo cp -r $DIR/icons/* /usr/share/icons/
}

install_scripts() {
	print_status "Installing scripts..."
	sudo install -Dm755 ./scripts/* -t /usr/local/bin/ >>/tmp/.terraform.log 2>&1
}

install_plymouth_themes() {
	print_status "Installing plymouth themes..."
	sudo mkdir -p /usr/share/plymouth/ >>/tmp/.terraform.log 2>&1
	sudo cp -r plymouth-themes/themes /usr/share/plymouth/ >>/tmp/.terraform.log 2>&1
}

install_wallpapers() {
	print_status "Installing wallpapers..."
	sudo cp -r $DIR/genos-wallpapers /usr/share/backgrounds/
}

install_lxdm_theme() {
	print_status "Installing lxdm theme..."
	mkdir -p /usr/share/lxdm/themes/ >>/tmp/.terraform.log 2>&1
	sudo cp -r ./lxdm/theme/genos /usr/share/lxdm/themes/ >>/tmp/.terraform.log 2>&1
	mkdir -p /etc/lxdm/ >>/tmp/.terraform.log 2>&1
	sudo cp -r ./lxdm/lxdm.conf /etc/lxdm/lxdm.conf >>/tmp/.terraform.log 2>&1
}


harden_networkmanager() {
	sudo cp $DIR/NetworkManager/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf
	sudo cp $DIR/NetworkManager/20-connectivity.conf /etc/NetworkManager/conf.d/
}


install_go_packages() {
	must_exist "go"
	mkdir -p $HOME/go
	export GOPATH="$HOME/go"

	while IFS='' read -r line || [[ -n "$line" ]]; do
		go get -v -u $line
	done < <(grep -v "#" golang_packages.txt | sort -u)

}

## Main
banner
enable_multilib
install_pacman_packages
install_yay_packages
install_git_packages
install_dotfiles
install_scripts
install_fonts
install_icons
install_wallpapers
install_lxdm_theme
install_plymouth_theme
install_go_packages
harden_networkmanager

print_good "All done!"
exit 0
