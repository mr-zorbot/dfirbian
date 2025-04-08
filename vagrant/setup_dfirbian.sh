#!/usr/bin/env bash

# Upgrades the base system before tool installation.
sys_upgrade () {
  sudo apt-get update && sudo apt-get upgrade -y
}

# Install software via APT.
apt_install () {
  echo "wireshark-common wireshark-common/install-setuid boolean false" | sudo debconf-set-selections # Sets the wireshark-common package to not use setuid during installation. Without this line, Vagrant would crash.
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y fish jq tmux build-essential pkgconf binutils gnupg2 git unzip curl wget htop pipx bc vim xxd testdisk sleuthkit termshark
}

# Install Volatility3 - via PIP - for memory forensics.
vol3_install () {
  pipx install volatility3
}

# Install Radare2 - from source - for reverse engineering. 
radare2_install () {
  git clone https://github.com/radareorg/radare2
  ./radare2/sys/install.sh
}

# Install Wine to allow debug windows binaries.
wine_install () {
  sudo dpkg --add-architecture i386
  sudo mkdir -pm755 /etc/apt/keyrings
  wget -O - https://dl.winehq.org/wine-builds/winehq.key | sudo gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key -
  sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources
  sudo apt-get update
  sudo apt-get install -y --install-recommends winehq-devel
}

# Install CyberChef
cyberchef_install () {
  destination_dir="$HOME/.local/share/CyberChef"
  download_url=$(curl -s "https://api.github.com/repos/gchq/CyberChef/releases/latest" | jq -r '.assets[0].browser_download_url')
  mkdir -p $destination_dir
  wget -O $destination_dir/cyberchef.zip $download_url
  unzip $destination_dir/cyberchef.zip -d $destination_dir
  ln -s $destination_dir/*.html $destination_dir/index.html
}

# Configure user shell.
shell_config () { 
  sudo chsh -s /usr/bin/fish vagrant # Make fish the default shell.
  mkdir -p $HOME/.config/fish/conf.d/
  curl https://raw.githubusercontent.com/mr-zorbot/MyDotFiles/refs/heads/master/.config/fish/config.fish | grep -v lvim > $HOME/.config/fish/config.fish
  curl https://raw.githubusercontent.com/mr-zorbot/MyDotFiles/refs/heads/master/.tmux.conf > $HOME/.tmux.conf
  curl https://raw.githubusercontent.com/mr-zorbot/MyDotFiles/refs/heads/master/.config/fish/conf.d/tmux.fish > $HOME/.config/fish/conf.d/tmux.fish # This makes tmux run automatically after login.
  curl https://raw.githubusercontent.com/mr-zorbot/MyDotFiles/refs/heads/master/.config/fish/conf.d/cyberchef.fish >  $HOME/.config/fish/conf.d/cyberchef.fish # This allows access to CyberChef from the host on port 8000 of the VM.
}

main () {
  sys_upgrade
  apt_install
  wine_install
  vol3_install
  cyberchef_install
  radare2_install
  shell_config
}

main
