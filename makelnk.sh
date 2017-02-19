#!/usr/bin/env bash

ln -sf $(pwd)/inputrc  ~/.inputrc
ln -sf $(pwd)/bashrc   ~/.bashrc

mkdir  ~/.config/nvim
ln -sf $(pwd)/vimrc ~/.config/nvim/init.vim
ln -sf $(pwd)/vimrc ~/.vimrc

