#!/bin/bash
#set -e
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

if grep -q "RebornOS" /etc/os-release; then

	echo
	tput setaf 2
	echo "################################################################"
	echo "################### We are on RebornOS"
	echo "################################################################"
	tput sgr0
	echo

	# echo "Removing conflicting folders"
	# sudo rm /etc/skel/.zshrc
	# sudo rm -r /etc/skel/.config/Thunar
	
	# echo
	# echo "Installing edu packages"
	# sudo pacman -S --noconfirm --needed edu-skel-git
  	# sudo pacman -S --noconfirm --needed edu-xfce-git
  	# sudo pacman -S --noconfirm --needed edu-system-git

	echo
	echo "Pacman parallel downloads	"
	FIND="ParallelDownloads = 16"
	REPLACE="ParallelDownloads = 20"
	sudo sed -i "s/$FIND/$REPLACE/g" /etc/pacman.conf

	echo
	echo "Bootloader time to 1 second"
	if [ -f /boot/loader/loader.conf ]; then
		FIND="timeout 5"
		REPLACE="timeout 1"
		sudo sed -i "s/$FIND/$REPLACE/g" /boot/loader/loader.conf

	fi
	echo

	echo
	echo "Adding nanorc"
	if [ -f /etc/nanorc ]; then
    	sudo cp $installed_dir/settings/nano/nanorc /etc/nanorc
	fi

	echo	
	echo "When on Xfce4"
	if [ -f /usr/share/xsessions/xfce.desktop ]; then
		echo
		tput setaf 2
		echo "################################################################"
		echo "################### We are on Xfce4"
		echo "################################################################"
		tput sgr0
		echo

		# cp -arf /etc/skel/. ~
		# cp -arf /etc/skel/.config ~

		echo "Changing theme and icon theme"
		cp $installed_dir/settings/rebornos/xfce/xsettings.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml


	fi

	echo
	tput setaf 6
	echo "################################################################"
	echo "################### Done"
	echo "################################################################"
	tput sgr0
	echo

fi

