#!/bin/bash

# Utils
function is_installed {
  # set to 1 initially
  local return_=1
  # set to 0 if not found
  type $1 >/dev/null 2>&1 || { local return_=0;  }
  # return
  echo "$return_"
}

function install_wsl2 {
  if [ "$(is_installed brew)" == "0" ]; then
    echo "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> ~/.profile
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi

  if [ "$(is_installed zsh)" == "0" ]; then
    echo "Installing zsh"
    # brew install zsh zsh-completions
    sudo apt install zsh -y
  fi

  if ! [ -d ~/.oh-my-zsh ]; then
    echo "Installing oh-my-zsh"
    # unset ZSH
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi

  if [ ! -d "$ZSH/custom/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions"
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH/custom/plugins/zsh-autosuggestions
  fi

  if [ "$(is_installed ag)" == "0" ]; then
    echo "Installing The silver searcher"
    brew install the_silver_searcher
  fi

  if [ "$(is_installed fzf)" == "0" ]; then
    echo "Installing fzf"
    brew install fzf
    /opt/homebrew/opt/fzf/install
  fi

  if [ "$(is_installed tmux)" == "0" ]; then
    echo "Installing tmux"
    brew install tmux
  fi

  if [ ! -d ~/.tmux ]; then
    #echo "Installing reattach-to-user-namespace"
    #brew install reattach-to-user-namespace
    echo "Installing tmux-plugin-manager"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    tmux source ~/.tmux.conf
  fi

  if [ "$(is_installed git)" == "0" ]; then
    echo "Installing Git"
    brew install git
  fi

  if [ "$(is_installed gh)" == "0" ]; then
    echo "Installing Github CLI"
    brew install gh
  fi

  if [ "$(is_installed nvim)" == "0" ]; then
    echo "Install neovim"
    brew install neovim
    if [ "$(is_installed pip3)" == "1" ]; then
      pip3 install neovim --upgrade
    fi

    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi

  if [ "$(is_installed node)" == "0" ]; then
    echo "Install NodeJS"
    curl -sL install-node.vercel.app/lts | sudo bash -
  fi

  if [ "$(is_installed tldr)" == "0" ]; then
    echo "Install TLDR"
    sudo npm install -g tldr
  fi
}

function link_dotfiles {
  echo "Linking dotfiles"

  rm -rf $HOME/.config/nvim/init.vim
  rm -rf $HOME/.config/nvim
  rm -rf $HOME/.vim/bundle/*
  
  rm -rf ~/.zshrc
  rm -rf ~/.tmux.conf
  rm -rf ~/.vim
  rm -rf ~/.vimrc
  rm -rf ~/.vimrc.bundles

  ln -s $(pwd)/zshrc ~/.zshrc
  ln -s $(pwd)/tmux.conf ~/.tmux.conf
  ln -s $(pwd)/vim ~/.vim
  ln -s $(pwd)/vimrc ~/.vimrc
  ln -s $(pwd)/vimrc.bundles ~/.vimrc.bundles

  mkdir -p $HOME/.config

  rm -rf $HOME/.config/nvim
  rm -rf $HOME/.config/nvim/init.vim
  rm -rf $HOME/.oh-my-zsh/themes/dracula.zsh-theme
  rm -rf $HOME/.oh-my-zsh/themes/lib

  ln -s $(pwd)/vim $HOME/.config/nvim
  ln -s $(pwd)/vimrc $HOME/.config/nvim/init.vim
  ln -s $(pwd)/schemes/dracula.zsh-theme $HOME/.oh-my-zsh/themes/dracula.zsh-theme
  ln -s $(pwd)/schemes/lib $HOME/.oh-my-zsh/themes/lib

  if [[ ! -f ~/.zshrc.local ]]; then
    echo "Creating .zshrc.local"
    touch ~/.zshrc.local
  fi
}

while test $# -gt 0; do 
  case "$1" in
    --wsl2)
      install_wsl2
      link_dotfiles
      zsh
      source ~/.zshrc
      # config zsh as default
      chsh -s $(which zsh)
      exit
      ;;
    --dotfiles)
      link_dotfiles
      exit
      ;;
  esac

  shift
done
