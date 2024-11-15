#!/bin/bash
# set -e
##################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Website   : https://www.alci.online
# Website   : https://www.ariser.eu
# Website   : https://www.arcolinux.info
# Website   : https://www.arcolinux.com
# Website   : https://www.arcolinuxd.com
# Website   : https://www.arcolinuxb.com
# Website   : https://www.arcolinuxiso.com
# Website   : https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################
#tput setaf 0 = black
#tput setaf 1 = red
#tput setaf 2 = green
#tput setaf 3 = yellow
#tput setaf 4 = dark blue
#tput setaf 5 = purple
#tput setaf 6 = cyan
#tput setaf 7 = gray
#tput setaf 8 = light blue
##################################################################################################################

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

##################################################################################################################

echo
tput setaf 2
echo "################################################################"
echo "################### Personal choices"
echo "################################################################"
tput sgr0
echo

# installing extra shell
sudo pkg install -y fish

# making sure simplescreenrecorder, virtualbox and other apps are dark
sudo cp environment /etc/environment
# .config I would like to have
cp -rv dotfiles/* ~/.config
# theme, cursor, icons, ...
cp -v .gtkrc-2.0 ~

# double - also in install-chadwm for convenience
[ -d $HOME"/.config/Thunar" ] || mkdir -p $HOME"/.config/Thunar"
cp -v uca.xml ~/.config/Thunar/

# changing the appearance of GDM - no bottom logo (ubuntu text)
sudo cp -v empty.png /usr/share/pixmaps/ubuntu-logo-text-dark.png
sudo cp -v empty.png /usr/share/pixmaps/ubuntu-logo-text.png
sudo cp -v empty.png /usr/share/plymouth/ubuntu-logo.png
sudo cp -v empty.png /usr/share/plymouth/themes/spinner/watermark.png

# setting the cursor to bibata everywhere
cp -rv default ~/.icons
sudo rm -r /usr/share/icons/default
sudo cp -rv default /usr/share/icons/

# personal folders I like to have
[ -d $HOME"/DATA" ] || mkdir -p $HOME"/DATA"
[ -d $HOME"/Insync" ] || mkdir -p $HOME"/Insync"
[ -d $HOME"/Projects" ] || mkdir -p $HOME"/Projects"
[ -d $HOME"/.themes" ] || mkdir -p $HOME"/.themes"
[ -d $HOME"/.icons" ] || mkdir -p $HOME"/.icons"

# setting my personal configuration for variety
echo "getting latest variety config from github"
sudo wget https://raw.githubusercontent.com/erikdubois/arcolinux-nemesis/master/Personal/settings/variety/variety.conf -O ~/.config/variety/variety.conf

# kill my system and go to GDM - CTRL ALT BACKSPACE
sudo cp 99-killX.conf  /etc/X11/xorg.conf.d/

# minimal setup for bashrc
if [ -f ~/.bashrc ]; then
	echo '
### EXPORT ###
export EDITOR='nano'
export VISUAL='nano'
export HISTCONTROL=ignoreboth:erasedups
export PAGER='most'

alias update="sudo pkg update && sudo pkg upgrade"
alias probe="sudo -E hw-probe -all -upload"
alias nenvironment="sudo $EDITOR /etc/environment"
alias sr="reboot"' | tee -a ~/.bashrc
fi

# Going for fish as the default shell
chsh -s /usr/local/bin/fish
echo

echo
echo "Removing all the messages virtualbox produces"
echo

VBoxManage setextradata global GUI/SuppressMessages "all"

# when on real metal install a template
# Check system hardware information
hw_machine=$(sysctl -n hw.machine)
hw_model=$(sysctl -n hw.model)

# Function to check for virtualization keywords
is_virtual_machine() {
    case "$hw_model" in
        *"VirtualBox"*) return 0 ;;
        *"QEMU"*) return 0 ;;
        *"KVM"*) return 0 ;;
        *"VMware"*) return 0 ;;
        *"Hyper-V"*) return 0 ;;
        *) return 1 ;;
    esac
}

# Perform actions based on whether it's a VM
if is_virtual_machine; then
	echo
	tput setaf 3
	echo "#########################################################################"
	echo "### You are on a virtual machine - skipping"
	echo "#########################################################################"
	tput sgr0
	echo

else
    echo
	tput setaf 3
	echo "#########################################################################"
	echo "### NOT running in a virtual machine - installing template VirtualBox"
	echo "#########################################################################"
	tput sgr0
	echo
    	[ -d $HOME"/VirtualBox VMs" ] || mkdir -p $HOME"/VirtualBox VMs"
	sudo cp -rf template.tar.gz ~/VirtualBox\ VMs/
	cd ~/VirtualBox\ VMs/
	tar -xzf template.tar.gz
	rm -f template.tar.gz	
fi

# getting archlinux-logout
cd $installed_dir
if [ -d /tmp/archlinux-logout ];then
	sudo rm -r /tmp/archlinux-logout
fi
git clone https://github.com/arcolinux/archlinux-logout /tmp/archlinux-logout
sudo cp -r /tmp/archlinux-logout/etc/* /etc
sudo cp -r /tmp/archlinux-logout/usr/* /usr
sudo rm -r /usr/share/archlinux-betterlockscreen
sudo rm /usr/share/applications/archlinux-betterlockscreen.desktop

# personalisation of archlinux-logout
[ -d $HOME"/.config/archlinux-logout" ] || mkdir -p $HOME"/.config/archlinux-logout"
cp -v archlinux-logout.conf ~/.config/archlinux-logout/

# prevention ads - tracking - hblock
# https://github.com/hectorm/hblock
if [ -d /tmp/hblock ];then
	sudo rm -r /tmp/hblock
fi
git clone https://github.com/hectorm/hblock  /tmp/hblock
cd /tmp/hblock
sudo make install
hblock

# Arc Dawn
if [ -d /tmp/arcolinux-arc-dawn ];then
	sudo rm -r /tmp/arcolinux-arc-dawn
fi
git clone https://github.com/arcolinux/arcolinux-arc-dawn  /tmp/arcolinux-arc-dawn
cd /tmp/arcolinux-arc-dawn/usr/share/themes

cp -r * ~/.themes

echo
FIND="export GTK_THEME=Arc-Dark"
REPLACE="export GTK_THEME=Arc-Dawn-Dark"
sudo sed -i "s/$FIND/$REPLACE/g" /etc/environment

# installing sparklines/spark
sudo sh -c "curl https://raw.githubusercontent.com/holman/spark/master/spark -o /usr/local/bin/spark && chmod +x /usr/local/bin/spark"

tput setaf 6
echo "################################################################"
echo "###### Personal choices done - reboot for fish"
echo "################################################################"
tput sgr0
echo