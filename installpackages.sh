#!/usr/bin/env bash

sudo apt-get install git-core build-essential binutils-dev flex \
bison zlib1g-dev qt4-dev-tools libqt4-dev libncurses5-dev libiberty-dev \
libxt-dev rpm mercurial graphviz vim screen silversearcher-ag xdotool \
wmctrl xsel

#install neovim
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install neovim
pip install neovim

#insall pytorch
conda install pytorch torchvision cuda80 -c soumith

