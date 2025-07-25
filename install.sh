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

function install_macos {
  if [[ $OSTYPE != darwin* ]]; then
    return
  fi
  echo "MacOS detected"
  xcode-select --install

  if [ "$(is_installed brew)" == "0" ]; then
    echo "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  if [ ! -d "/Applications/iTerm.app" ]; then
    echo "Installing iTerm2"
    brew tap homebrew/cask
    brew install iterm2 --cask
  fi

  if [ "$(is_installed zsh)" == "0" ]; then
    echo "Installing zsh"
    brew install zsh zsh-completions
  fi

  if [[ ! -d ~/.oh-my-zsh ]]; then
    echo "Installing oh-my-zsh"
    unset ZSH
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
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
    echo "Installing reattach-to-user-namespace"
    brew install reattach-to-user-namespace
    echo "Installing tmux-plugin-manager"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
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
}

function backup {
  echo "Backing up dotfiles"
  local current_date=$(date +%s)
  local backup_dir=dotfiles_$current_date

  mkdir ~/$backup_dir

  mv ~/.zshrc ~/$backup_dir/.zshrc
  mv ~/.tmux.conf ~/$backup_dir/.tmux.conf
  mv ~/.config/nvim ~/$backup_dir/.config/nvim
}

function link_dotfiles {
  echo "Linking dotfiles"

  ln -s $(pwd)/zsh/zshrc ~/.zshrc
  ln -s $(pwd)/tmux/tmux.conf ~/.tmux.conf

  rm -rf $HOME/.config/nvim
  mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
  ln -s $(pwd)/nvim $XDG_CONFIG_HOME/nvim

  rm -rf $HOME/.oh-my-zsh/themes/dracula.zsh-theme
  ln -s $(pwd)/schemes/dracula.zsh-theme $HOME/.oh-my-zsh/themes/dracula.zsh-theme

  if [[ ! -f ~/.zshrc.local ]]; then
    echo "Creating .zshrc.local"
    touch ~/.zshrc.local
  fi
}

while test $# -gt 0; do 
  case "$1" in
    --help)
      echo "Help"
      exit
      ;;
    --macos)
      install_macos
      backup
      link_dotfiles
      zsh
      source ~/.zshrc
      exit
      ;;
    --backup)
      backup
      exit
      ;;
    --dotfiles)
      link_dotfiles
      exit
      ;;
  esac

  shift
done
