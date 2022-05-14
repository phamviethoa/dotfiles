# dotfiles
A set of `vim`, `zsh`, and `tmux` configuration files for JavaScript Developer who likes to use Vim/NeoVim on macOS.

![Screenshot](screenshot.png)

Install
-------
Install On-My-Zsh:

  https://www.tecmint.com/install-oh-my-zsh-in-ubuntu/

Install z-zsh plugin:

    git clone https://github.com/agkozak/zsh-z $ZSH_CUSTOM/plugins/zsh-z

Install z-autosuggestion:

    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

Install NodeJS:

  https://heynode.com/tutorial/install-nodejs-locally-nvm/

Clone onto your machine:

    git clone git@github.com:phamviethoa/dotfiles.git

Simply run file:

    chmod +x ./install.sh

    ./install.sh --macos
    
In `vim/neovim` run:

    :PlugClean

And follow its steps.

After, in `vim/neovim` run:

    :PlugInstall

If you want to get newest version of `vim/neovim` plugin, in `vim/neovim` simply run:

    :PlugUpdate

Credit
-------

Thanks to:

https://github.com/dracula/dracula-theme/


