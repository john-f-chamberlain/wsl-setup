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
 `curl -sL https://raw.githubusercontent.com/john-f-chamberlain/wsl-setup/master/setup.sh | sudo bash -s`
