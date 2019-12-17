#!/usr/bin/env bash

sudo apt install python3-pip

#install neovim
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt install neovim

#install neovim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

sudo pip install --upgrade neovim

#insall pytorch
#conda install pytorch torchvision cuda80 -c soumith
