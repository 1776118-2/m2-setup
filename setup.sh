#!/bin/bash
# Color variables
blue='\033[0;34m'
yellow='\033[1;33m'
clear='\033[0m'

# Spinner Function
spin()
{
  spinner="◐◓◑◒◐◓◑◒"
  while :
  do
    for i in `seq 0 7`
    do
      echo -n "${spinner:$i:1}"
      echo -en "\010"
      sleep .1
    done
  done
}

# Initialization
cd ~
echo -e "${yellow}Please, type your password to start:${clear}"
echo $USER 'ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers &> /dev/null
echo "APT::Get::Assume-Yes "true";" >> 98forceyes &> /dev/null
sudo mv 98forceyes /etc/apt/apt.conf.d/.

# Initializating Spinner
spin &
SPIN_PID=$!
trap "kill -9 $SPIN_PID" `seq 0 15`

# Upgrading and Updating
echo -e "${blue}Checking for updates (It may take a while)...${clear}"
sudo apt-get update &> /dev/null

# Basic Install
echo -e "${blue}Installing basic dependencies...${clear}"
sudo apt-get install curl git wget zip software-properties-common openjdk-8-jdk apt-transport-https &> /dev/null

# Install Apache2
echo -e "${blue}Installing Apache 2...${clear}"
sudo apt-get install apache2 &> /dev/null
echo -e "${blue}Configuring Apache 2...${clear}"
sudo wget --no-check-certificate 'https://raw.githubusercontent.com/vpjoao98/m2-setup/master/src/apache2.conf' -O /etc/apache2/apache2.conf &> /dev/null
sudo sed -i 's/www-data/'$USER'/g' /etc/apache2/envvars
sudo a2enmod rewrite &> /dev/null
sudo service apache2 restart &> /dev/null
sudo chown -R $USER:$USER /var/www/html/
echo -e "${blue}Default localhost location set to /var/www/html...${clear}"

# Install PHP
echo -e "${blue}Adding PHP repository package...${clear}"
sudo add-apt-repository ppa:ondrej/php &> /dev/null
sudo apt-get update &> /dev/null
echo -e "${blue}Installing PHP 7.4...${clear}"
sudo apt-get install php7.4 php7.4-{bcmath,bz2,cli,common,curl,dba,dev,enchant,fpm,gd,gmp,imap,interbase,intl,json,ldap,mbstring,mcrypt,mysql,odbc,opcache,pgsql,phpdbg,pspell,readline,snmp,soap,sqlite3,sybase,tidy,xml,xmlrpc,xsl,xdebug,zip} &> /dev/null
sudo apt-get install libapache2-mod-php7.4 &> /dev/null
sudo a2enmod php7.4 &> /dev/null
echo -e "${blue}Installing PHP 7.3...${clear}"
sudo apt-get install php7.3 php7.3-{bcmath,bz2,cli,common,curl,dba,dev,enchant,fpm,gd,gmp,imap,interbase,intl,json,ldap,mbstring,mcrypt,mysql,odbc,opcache,pgsql,phpdbg,pspell,readline,recode,snmp,soap,sqlite3,sybase,tidy,xml,xmlrpc,xsl,xdebug,zip} &> /dev/null
sudo apt-get install libapache2-mod-php7.3 &> /dev/null
sudo a2enmod php7.3 &> /dev/null

# Install MySQL
echo -e "${blue}Installing MySQL...${clear}"
sudo apt install mysql-server &> /dev/null

# Configuring MySQL
echo -e "${blue}Configuring MySQL...${clear}"
sudo mysql -e "DELETE FROM mysql.user WHERE User='';"
sudo mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
sudo mysql -e "DROP DATABASE IF EXISTS test;"
sudo mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '';"
sudo mysql -e "FLUSH PRIVILEGES"

# Install ElasticSearch
echo -e "${blue}Installing ElasticSearch...${clear}"
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add - &> /dev/null
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list &> /dev/null
sudo apt-get update &> /dev/null
sudo apt-get install elasticsearch &> /dev/null
sudo systemctl daemon-reload &> /dev/null
sudo systemctl enable elasticsearch.service &> /dev/null
sudo systemctl start elasticsearch.service &> /dev/null

# Install NodeJS, NPM and Grunt
echo -e "${blue}Installing NodeJS, NPM and Grunt...${clear}"
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash - &> /dev/null
sudo apt-get update &> /dev/null
sudo apt-get install nodejs &> /dev/null
sudo npm install -g grunt-cli &> /dev/null

# Install Composer
echo -e "${blue}Installing Composer...${clear}"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" &> /dev/null
php -r "if (hash_file('sha384', 'composer-setup.php') === '906a84df04cea2aa72f40b5f787e49f22d4c2f19492ac310e8cba5b96ac8b64115ac402c8cd292b8a03482574915d1a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" &> /dev/null
php composer-setup.php &> /dev/null
php -r "unlink('composer-setup.php');" &> /dev/null
sudo mv composer.phar /usr/local/bin/composer &> /dev/null
sudo composer self-update --1 &> /dev/null

# Install DBeaver
echo -e "${blue}Installing DBeaver...${clear}"
sudo add-apt-repository ppa:serge-rider/dbeaver-ce &> /dev/null
sudo apt-get update &> /dev/null
sudo apt-get install dbeaver-ce &> /dev/null

# Install Insomnia
echo -e "${blue}Installing Insomnia...${clear}"
sudo snap install insomnia --classic &> /dev/null

# Install PHPStorm
echo -e "${blue}Installing PHPStorm...${clear}"
sudo snap install phpstorm --classic &> /dev/null

# Install VSCode
echo -e "${blue}Installing VSCode...${clear}"
sudo snap install code --classic &> /dev/null

# Install Orchis-theme
echo -e "${blue}Installing Orchis Theme...${clear}"
sudo apt-get install libsass0 &> /dev/null
sudo apt-get install sassc &> /dev/null
mkdir -p ~/Themes/Orchis
git clone https://github.com/vinceliuice/Orchis-theme.git ~/Themes/Orchis &> /dev/null
~/Themes/Orchis/install.sh -t grey &> /dev/null

# Install Tela Icons
echo -e "${blue}Installing Tela Icons Pack...${clear}"
mkdir -p ~/Themes/Tela
git clone https://github.com/vinceliuice/Tela-icon-theme Themes/Tela &> /dev/null
~/Themes/Tela/install.sh -a &> /dev/null

# Configure Theme
echo -e "${blue}Configuring Theme...${clear}"
wget --no-check-certificate 'https://raw.githubusercontent.com/vpjoao98/m2-setup/master/src/wallpaper.jpg' -O ~/Pictures/wallpaper.jpg &> /dev/null
gsettings set org.gnome.desktop.background picture-uri 'file:///home/'$USER'/Pictures/wallpaper.jpg'
gsettings set org.gnome.desktop.background picture-options 'zoom'
gsettings set org.gnome.desktop.interface gtk-theme 'Orchis-grey-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Tela'
gsettings set org.gnome.desktop.interface cursor-theme 'Tela'
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
gsettings set org.gnome.shell.extensions.dash-to-dock autohide true
gsettings set org.gnome.shell.extensions.dash-to-dock apply-custom-theme true
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 30

# Install Zsh
echo -e "${blue}Installing Zsh...${clear}"
sudo apt install zsh &> /dev/null

# Install Oh-my-zsh
echo -e "${blue}Installing Oh-my-zsh...${clear}"
sudo sed -i 's/auth       required   pam_shells.so/auth       sufficient       pam_shells.so/g' /etc/pam.d/chsh
wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh &> /dev/null
chmod +x install.sh
./install.sh --unattended &> /dev/null
rm install.sh
chsh -s $(which zsh)

# Install Oh-my-zsh spaceship theme
echo -e "${blue}Installing Oh-my-zsh spaceship theme...${clear}"
git clone https://github.com/spaceship-prompt/spaceship-prompt.git "~/.oh-my-zsh/custom/themes/spaceship-prompt" --depth=1 &> /dev/null
ln -s "~/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme" "~/.oh-my-zsh/custom/themes/spaceship.zsh-theme" &> /dev/null

# Adding Zsh aliases and functions
echo -e "${blue}Adding zsh aliases and functions...${clear}"
mkdir ~/.zsh/
wget --no-check-certificate 'https://raw.githubusercontent.com/vpjoao98/m2-setup/master/src/.zsh_aliases' -O ~/.zsh/.zsh_aliases &> /dev/null
wget --no-check-certificate 'https://raw.githubusercontent.com/vpjoao98/m2-setup/master/src/.zsh_functions' -O ~/.zsh/.zsh_functions &> /dev/null
wget --no-check-certificate 'https://raw.githubusercontent.com/vpjoao98/m2-setup/master/src/.zshrc' -O ~/.zshrc &> /dev/null
echo -e "${clear}To show all zsh aliases and functions, just type ${yellow}zsh-aliases${clear}."

# Install Magento-Cloud
echo -e "${blue}Installing Magento-Cloud...${clear}"
curl -sS https://accounts.magento.cloud/cli/installer | php &> /dev/null

# Set up ssh
echo -e "${blue}Setting up default SSH...${clear}"
ssh-keygen -f ~/.ssh/default -P "" &> /dev/null

# Installing Google Chrome
echo -e "${blue}Installing Google Chrome...${clear}"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O ~/Downloads/chrome.deb &> /dev/null
sudo apt-get install ~/Downloads/chrome.deb &> /dev/null
rm ~/Downloads/chrome.deb

# Finishing
echo -e "${blue}Cleaning up...${clear}"
sudo rm /etc/apt/apt.conf.d/98forceyes
sudo sed -i 's/auth       sufficient       pam_shells.so/auth       required       pam_shells.so/g' /etc/pam.d/chsh
sudo sed -i '$d' /etc/sudoers
sudo service apache2 restart &> /dev/null
sudo service mysql restart &> /dev/null

# Ending Spinner
kill -9 $SPIN_PID &> /dev/null

# Reboot
echo -e "${yellow}A reboot is needed to finish setup. Do you want to reboot now? (y|Y for Yes, any other key to No)${clear}"
read key
echo -e "${yellow}Setup Ended.${clear}"

if [[ "$key" =~ ^([yY])$ ]]
then
    sudo reboot
fi
