#!/usr/bin/env bash

ln -sf $(pwd)/inputrc  ~/.inputrc
ln -sf $(pwd)/bashrc   ~/.bashrc
ln -sf $(pwd)/screenrc   ~/.screenrc

mkdir  ~/.config/nvim
ln -sf $(pwd)/vimrc ~/.config/nvim/init.vim
