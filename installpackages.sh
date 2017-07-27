#!/usr/bin/env bash

sudo apt-get install git-core build-essential binutils-dev flex \
bison zlib1g-dev qt4-dev-tools libqt4-dev libncurses5-dev libiberty-dev \
libxt-dev rpm mercurial graphviz vim screen silversearcher-ag xdotool \
wmctrl xsel cmake python-dev python3-dev

#install neovim
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install neovim
pip install neovim

#insall pytorch
conda install pytorch torchvision cuda80 -c soumith

#install neovim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
