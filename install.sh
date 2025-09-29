#!/bin/bash

function is_installed {
  # set to 1 initially
  local return_=1
  # set to 0 if not found
  type $1 >/dev/null 2>&1 || { local return_=0; }
  # return
  echo "$return_"
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

  if [ "$(is_installed nvim)" == "0" ]; then
    echo "Install neovim..."
    brew install neovim
    if [ "$(is_installed pip3)" == "1" ]; then
      pip3 install neovim --upgrade
    fi
  fi

  if [ "$(is_installed flashspace)" == "0" ]; then
    echo "Install workspace manager (flashspace)..."
    brew install flashspace
  fi

  if [ "$(is_installed claude)" == "0" ]; then
    echo "Install claude code..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    \. "$HOME/.nvm/nvm.sh"
    nvm install 22
    npm install -g @anthropic-ai/claude-code
  fi
}

function link_dotfiles {
  # Link zsh configuration directory and main zshrc
  mkdir -p ~/.config
  ln -sf $(pwd)/zsh ~/.config/zsh
  ln -sf ~/.config/zsh/zshrc ~/.zshrc
  ln -sf $(pwd)/schemes/dracula.zsh-theme "$HOME"/.oh-my-zsh/themes/dracula.zsh-theme

  # Link tmux configuration
  mkdir -p ~/.local/bin
  ln -sf $(pwd)/tmux/tmux.conf ~/.tmux.conf
  ln -sf $(pwd)/tmux/tmux-sessionizer ~/.local/bin/tmux-sessionizer
  chmod +x ~/.local/bin/tmux-sessionizer

  # Link neovim configuration
  ln -sf $(pwd)/nvim ~/.config/nvim
}

function check_installation {
  echo "Checking installation..."

  local all_good=true

  # Check tools
  for tool in brew zsh tmux nvim fzf ag git gh; do
    if command -v $tool >/dev/null 2>&1; then
      echo "✓ $tool is installed"
    else
      echo "✗ $tool is NOT installed"
      all_good=false
    fi
  done

  # Check symlinks
  for link in ~/.zshrc ~/.tmux.conf ~/.local/bin/tmux-sessionizer ~/.config/nvim ~/.config/zsh; do
    if [ -L "$link" ]; then
      echo "✓ $link is linked"
    else
      echo "✗ $link is NOT linked"
      all_good=false
    fi
  done

  if [ "$all_good" = true ]; then
    echo -e "\n✓ All checks passed!"
  else
    echo -e "\n✗ Some checks failed. Run ./install.sh --macos or ./install.sh --dotfiles"
  fi
}

function show_help {
  cat <<'EOF'
Usage: install.sh [options]

Options:
  --help        Show this help message
  --macos       Setup for MacOS machine
  --dotfiles    Run link dotfiles only
  --check       Verify installation and symlinks
  --dry-run     Show what would be installed without making changes
EOF
}

DRY_RUN=false

while test $# -gt 0; do
  case "$1" in
  --help)
    show_help
    exit
    ;;
  --dry-run)
    DRY_RUN=true
    echo "DRY RUN MODE - No changes will be made"
    echo "---"
    ;;
  --check)
    check_installation
    exit
    ;;
  --macos)
    if [ "$DRY_RUN" = true ]; then
      echo "Would install: Homebrew, Xcode tools, iTerm2, zsh, neovim, tmux, fzf, ag, git, gh, flashspace, claude"
      echo "Would link: zsh, tmux, nvim configs"
    else
      install_macos
      link_dotfiles
      zsh
      source ~/.zshrc
    fi
    exit
    ;;
  --dotfiles)
    if [ "$DRY_RUN" = true ]; then
      echo "Would create symlinks:"
      echo "  $(pwd)/zsh -> ~/.config/zsh"
      echo "  ~/.config/zsh/zshrc -> ~/.zshrc"
      echo "  $(pwd)/tmux/tmux.conf -> ~/.tmux.conf"
      echo "  $(pwd)/tmux/tmux-sessionizer -> ~/.local/bin/tmux-sessionizer"
      echo "  $(pwd)/nvim -> ~/.config/nvim"
    else
      link_dotfiles
    fi
    exit
    ;;
  esac

  shift
done
