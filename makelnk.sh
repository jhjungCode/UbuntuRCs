#!/usr/bin/env bash

ln -sf $(pwd)/inputrc  ~/.inputrc
ln -sf $(pwd)/bashrc   ~/.bashrc
ln -sf $(pwd)/screenrc   ~/.screenrc
ln -sf $(pwd)/onirc   ~/.config/oni

mkdir  ~/.config/nvim
ln -sf $(pwd)/vimrc ~/.config/nvim/init.vim
mkdir ~/.config/oni
ln -sf $(pwd)/onirc/config.js ~/.config/oni
ln -sf $(pwd)/onirc/init.vim ~/.config/oni
