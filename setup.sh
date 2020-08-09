#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

# Set nameservers... sometimes WSL
echo -e '[network]\ngenerateResolvConf = false' > /etc/wsl.conf
echo -e 'nameserver 1.1.1.1\nnameserver 1.0.0.1' > /etc/resolv.conf

echo "Installing Prerequisites...";
# Fix for: gpg: can't connect to the agent: IPC connect call failed
add-apt-repository ppa:rafaeldtinoco/lp1871129
apt-get update -y
apt-get upgrade -y
apt-get dist-upgrade -y
apt-get install -y build-essential gcc g++ make curl git vim unzip php-cli php-dom php-mbstring php-pear php-curl \
                   php-dev php-gd php-zip php-mysql php-xml php-imagick php-tidy php-xmlrpc php-intl
apt-get install -y --allowdowngrades libc6=2.31-0ubuntu8+lp1871129~1 libc6-dev=2.31-0ubuntu8+lp1871129~1 \
                   libc-dev-bin=2.31-0ubuntu8+lp1871129~1
apt-mark hold libc6

# Installing Composer
curl -sS https://getcomposer.org/installer -o composer-setup.php
HASH=`curl -sS https://composer.github.io/installer.sig`
TEST=`php -r "if (hash_file('SHA384', 'composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"`
if [[ ${TEST} = "Installer Corrupt" ]]; then
    exit 1
fi
php composer-setup.php --install-dir=/usr/local/bin --filename=composer
composer -v
echo "Composer Installed Successfully...";

echo "Installing NodeJS";
curl -sL https://deb.nodesource.com/setup_12.x | bash -s
apt install nodejs -y

echo "NodeJS installed successfully";

echo "Creating Projects Directory...";
mkdir -p "/mnt/c/Projects/";

echo "Creating KeyPair...";
sudo -u $SUDO_USER bash -c "ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_github -C 'Github WSL'"

echo "Add the following key to your Github Account for SSH to work easily:"
echo "Link: https://github.com/settings/ssh/new";
echo "===================================================";
echo "";

sudo -u $SUDO_USER bash -c "cat ~/.ssh/id_github.pub"

echo ""
echo "===================================================";
echo "Note: The above key is already in your clipboard :-D";
sudo -u $SUDO_USER bash -c "cat ~/.ssh/id_github.pub | /mnt/c/Windows/system32/clip.exe"

/mnt/c/Windows/System32/WindowsPowerShell/v1.0//powershell.exe /c start https://github.com/settings/ssh/new
read -n 1 -p "Press any key to continue.";
echo ""; # Forces a fresh line.

echo "Adding SSH configuration entries for GitHub..."
sudo -u $SUDO_USER bash -c "echo -e 'Host github.com\n\tHostname github.com\n\tUser git\n\tIdentityFile ~/.ssh/id_github' >> ~/.ssh/config;"

echo "Adding GitHub to known_hosts"
host="github.com"
fingerprint="SHA256:nThbg6kXUpJWGl7E1IGOCspRomTxdCARLviKw6E5SY8"

keys=$(ssh-keyscan -t rsa $host)

# Iterate over keys (host and ip)
while IFS= read -r key; do
    # Extract Host name (or IP)
    key_host=$(echo $key | awk '{ print $1 }')

    # Extracting fingerprint of key
    key_fingerprint=$(echo $key | ssh-keygen -lf - | awk '{ print $2 }')

    # Check that fingerprint matches one provided as second parameter
    if [[ $fingerprint != $key_fingerprint ]]; then
      echo "Fingerprint match failed: '$fingerprint' (expected) != '$key_fingerprint' (got)";
      exit 1;
    fi

    # Add key to known_hosts if it doesn't exist
    if ! sudo -u $SUDO_USER bash -c "grep $key_host ~/.ssh/known_hosts > /dev/null"
    then
       echo "Adding fingerprint $key_fingerprint for $key_host to ~/.ssh/known_hosts"
       sudo -u $SUDO_USER bash -c "echo $key >> ~/.ssh/known_hosts"
    fi
done <<< "$keys"

echo "Verifying key was added..."
TEST2=`sudo -u $SUDO_USER bash -c "ssh git@github.com | grep 'successfully authenticated'"`
if [[ ${TEST} = "" ]]; then
    echo "Your SSH key wasn't added properly to your GitHub account.";
else
    echo "SSH key verified! You should be all set for GitHub now!"
fi
