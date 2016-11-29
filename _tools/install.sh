#!/bin/bash -e

echo "---------------------------------------------"
echo 
echo "        Starting server installation"
echo 
echo


# GET INSTALL USER
install_user=$(who am i | awk '{print $1}')
export install_user


echo
echo "Installing system for $install_user"
echo

read -p "Please enter your email address: " install_email
export install_email


# SETTING DEFAULT GIT USER
git config --global core.filemode false
git config --global user.name "$install_user"
git config --global user.email "$install_email"
git config --global credential.helper cache



echo
echo
echo "Setting timezone to: Europe/Copenhagen"
echo
sudo timedatectl set-timezone "Europe/Copenhagen"


# MAKE SITES FOLDER
if [ ! -d "/srv/sites" ]; then
	mkdir /srv/sites
fi

# MAKE CONF FOLDER
if [ ! -d "/srv/conf" ]; then
	mkdir /srv/conf
fi


# INSTALL SECURITY
. /srv/tools/_tools/install_security.sh

# INSTALL SOFTWARE
. /srv/tools/_tools/install_software.sh

# INSTALL HTACCESS PASSWORD
. /srv/tools/_tools/install_htaccess.sh

# INSTALL WEBSERVER CONFIGURATION
. /srv/tools/_tools/install_webserver_configuration.sh

# INSTALL FFMPEG
. /srv/tools/_tools/install_ffmpeg.sh



echo
echo
echo "Copying terminal configuration"
echo
# ADD COMMANDS ALIAS'
cat /srv/tools/_conf/dot_profile > /home/$install_user/.profile


# GET PORT NUMBER AND IP ADDRESS
port_number=$(grep -E "^Port\ ([0-9]+)$" /etc/ssh/sshd_config | sed "s/Port //;")
ip_address=$(dig +short myip.opendns.com @resolver1.opendns.com)

echo
echo
echo "Login command:"
echo
echo "ssh -p $port_number kaestel@$ip_address"
echo 
echo
echo "You are done!"
echo
echo "Reboot the server (sudo reboot)"
echo "and log in again (ssh -p $port_number kaestel@$ip_address)"
echo
echo
echo "See you in a bit "
echo

