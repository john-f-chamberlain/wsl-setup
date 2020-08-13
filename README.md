# wsl-setup

I use this script to automatically configure WSL for Composer/NodeJS development. I frequently reset WSL, so having this script helps me quite a bit.
 - Installs commonly packages ( unzip, git, etc)
 - Installs PHP7.4 and some frequently required extensions (dom, curl, mbstring, xml, mysql etc)
 - Installs Composer
 - Installs NodeJS 12.x ( as well as configures a gpg workaround that's required in Ubuntu 20.04 )
 - Creates a Projects folder in the root of C:\
 - Creates an SSH key (id_github)
 - Prompts you to add SSH key to yur GitHub account
 - Adds entry to ~/.ssh/config to use the generated SSH key for github.
 - Adds github to known_hosts file
 - Verifies SSH key is associated with a GitHub account
 
 ## Usage
 I use this with the Ubuntu 20.04 LTS WSL available through the Microsoft store. YMMV with other editions.
 I'd suggest only using this on a fresh WSL installation, but it shouldn't really cause many issues on existing ones.
 To reset your WSL installation
  - Start Menu - Search for "Apps & Features"
  - Click on "Ubuntu 20.04 LTS"
  - Click "Advanced options"
  - Click "Reset"
  
Launch Ubuntu 20.04 LTS from your start menu and follow the initial configuration of adding a user account, then run the following command:

 `curl -sL https://raw.githubusercontent.com/john-f-chamberlain/wsl-setup/master/setup.sh | sudo bash -s`
