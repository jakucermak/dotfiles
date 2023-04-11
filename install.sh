#! /bin/bash

# Install necessary tools
tools=("neovim" "ranger" "tmux" "lsd" "bat" "zsh")


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
else
    echo "$os"
    echo "Installing necessary tools for Linux-GNU" ;
    for tool in ${tools[@]}; do
        echo "installing" $tool
        gnu_install $tool
    done
fi




# Install NeoVim Plugin Manager
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


# Install Oh-My-ZSH
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
curl -sS https://starship.rs/install.sh | sh
eval "$(starship init zsh)"

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
