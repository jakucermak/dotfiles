#! /bin/bash

# Install necessary tools
tools=("neovim" "ranger" "tmux" "bat" "zsh")


os="$OSTYPE"

darwin_install() {
    brew install $1
}

gnu_install() {
    sudo apt install $1 -y
}


if [[ $os == "darwin"* ]]; then
    echo "Installing necessary tools for macOS"
    for tool in ${tools[@]}; do
        echo "installing: " $tool
        darwin_install $tool
    done
    defaults write com.apple.dock "autohide-delay" -float "0" && killall Dock
else
    echo "$os"
    echo "Installing necessary tools for Linux-GNU" ;
    for tool in ${tools[@]}; do
        echo "installing" $tool
        gnu_install $tool
    done
    sudo apt install python3-venv
fi

# Install NeoVim Plugin Manager
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
# Intstall TmuxPlugin Manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install Oh-My-ZSH
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
curl -sS https://starship.rs/install.sh | sh
eval "$(starship init zsh)"

# Installing plugins for ohmyzsh
echo "Installing oh-my-zsh plugins"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting


############################
##   Creating symlinks   ###
############################

# Create configration folder
mkdir ~/.config

# Symlink to tmux config file
ln -s ~/dotFiles/tmux ~/.config/

#symlink to .zsh config file
rm ~/.zshrc
ln -s ~/dotFiles/.zshrc ~/.zshrc

#symlink to batcat config file
ln -s ~/dotFiles/bat/ ~/.config/

# symlink to nvim configuration
ln -s ~/dotFiles/nvim ~/.config/

#symlink to ranger FileManager
ln -s ~/dotFiles/ranger ~/.config/ranger
