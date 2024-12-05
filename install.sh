#! /bin/bash

# Install necessary tools
tools=("curl" "ranger" "tmux" "zsh" "tree")
rust_tools=("lsd" "bottom" "ripgrep" "bat")
echo "Install rust toolchain"

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"

# Attempting to get the Rust version
rust_version=$(rustc --version 2>&1)

# First, check for the error message "command not found"
if [[ $rust_version == *"command not found"* ]] || [[ $rust_version == *"rustc: command not found"* ]]; then
    echo -e "\033[31mRust is not installed.\033[0m"
    exit 1
# Then check for a successful installation
elif [[ $rust_version == *"rustc"* ]]; then
    echo "Rust is correctly installed!"
    echo $rust_version
    echo "Continues with installation of Rust tools"

	for tool in ${rust_tools[@]}; do
		echo "Installing" $tool
		cargo install $tool --locked
		if [ $? -eq 0 ]; then
			echo $tool "installed sucessfully"
		else
			echo -e "\033[31m $tool not installed\033[0m"
		fi
	done

else
    echo -e "\033[31mAn unknown error occurred while checking the Rust installation.\033[0m"
    echo -e "\033[31mOutput from the attempt to get the version: $rust_version \033[0m"
    exit 1
fi


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
echo "Istallining Neovim plugin manager"
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
# Intstall TmuxPlugin Manager
echo "Istallining Tmux plugin manager"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install Oh-My-ZSH
echo "Istallining Oh-My-ZSH plugin manager"
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
echo "Creating symlinks to configurations"
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

# symlink to yabai and skhd configs
ln -s ~/dotfiles/.yabairc ~/.yabairc
ln -s ~/dotfiles/.skhdrc ~/.skhdrc

# symlink to sketchybar config folder and install it
ln -s ~/dotfiles/sketchybar ~/.config/sketchybar
sh ~/.config/sketchybar/helpers/install.sh

# symlink to alacritty
ln -s ~/dotfiles/alacritty ~/.config/alacritty
