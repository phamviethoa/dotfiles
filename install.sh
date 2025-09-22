#!/bin/bash

function is_installed {
  # set to 1 initially
  local return_=1
  # set to 0 if not found
  type $1 >/dev/null 2>&1 || { local return_=0; }
  # return
  echo "$return_"
}

function install_databricks {
  echo "Installing Databricks Development"

  if [ "$(is_installed databricks)" == "0" ]; then
    echo "Installing Databricks CLI"
    brew tap databricks/tap
    brew install databricks
  fi
}

function install_macos {
  if [[ $OSTYPE != darwin* ]]; then
    return
  fi

  if ! xcode-select -p &>/dev/null; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
  fi

  if [ "$(is_installed brew)" == "0" ]; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  if [ ! -d "/Applications/iTerm.app" ]; then
    echo "Installing iTerm2..."
    brew tap homebrew/cask
    brew install iterm2 --cask
  fi

  if [ "$(is_installed zsh)" == "0" ]; then
    echo "Installing zsh..."
    brew install zsh zsh-completions
  fi

  if [[ ! -d ~/.oh-my-zsh ]]; then
    echo "Installing oh-my-zsh..."
    unset ZSH
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  fi

  if [ ! -d "$ZSH/custom/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH/custom/plugins/zsh-autosuggestions
  fi

  if [ "$(is_installed ag)" == "0" ]; then
    echo "Installing The silver searcher..."
    brew install the_silver_searcher
  fi

  if [ "$(is_installed fzf)" == "0" ]; then
    echo "Installing fzf..."
    brew install fzf
    /opt/homebrew/opt/fzf/install
  fi

  if [ "$(is_installed tmux)" == "0" ]; then
    echo "Installing tmux..."
    brew install tmux
    echo "Installing reattach-to-user-namespace..."
    brew install reattach-to-user-namespace
    echo "Installing tmux-plugin-manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi

  if [ "$(is_installed git)" == "0" ]; then
    echo "Installing Git..."
    brew install git
  fi

  if [ "$(is_installed gh)" == "0" ]; then
    echo "Installing Github CLI..."
    brew install gh
  fi

  if [ "$(is_installed aerospace)" == "0" ]; then
    echo "Installing Aerospace..."
    brew install --cask nikitabobko/tap/aerospace
  fi

  if [ "$(is_installed nvim)" == "0" ]; then
    echo "Install neovim..."
    brew install neovim
    if [ "$(is_installed pip3)" == "1" ]; then
      pip3 install neovim --upgrade
    fi
  fi
}

function link_dotfiles {
  ln -sf $(pwd)/zsh/zshrc ~/.zshrc
  ln -sf $(pwd)/schemes/dracula.zsh-theme "$HOME"/.oh-my-zsh/themes/dracula.zsh-theme

  mkdir -p ~/.local/bin
  ln -sf $(pwd)/tmux/tmux.conf ~/.tmux.conf
  ln -sf $(pwd)/tmux/tmux-sessionizer ~/.local/bin/tmux-sessionizer
  chmod +x ~/.local/bin/tmux-sessionizer

  mkdir -p ~/.config
  ln -sf $(pwd)/nvim ~/.config/nvim

  ln -sf $(pwd)/workspace-manager/.aerospace.toml ~/.aerospace.toml
}

function show_help {
  cat <<'EOF'
Usage: install.sh [options]

Options:
  --help        Show this help message
  --macos     	Setup for MacOS machine
  --dotfiles	Run link dotfiles only
  --databricks  Install packages for Databricks development
EOF
}

while test $# -gt 0; do
  case "$1" in
  --help)
    show_help
    exit
    ;;
  --macos)
    install_macos
    link_dotfiles
    zsh
    source ~/.zshrc
    exit
    ;;
  --dotfiles)
    link_dotfiles
    exit
    ;;
  --databricks)
    install_databricks
    exit
    ;;
  esac

  shift
done
