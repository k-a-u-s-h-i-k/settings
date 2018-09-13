#!/usr/bin/env bash

ln -s ~/.settings/spacemacs/spacemacs ~/.spacemacs

# install this for org mode tex/pdf exports
# This is going to download > 1GB of files...
sudo apt install texlive-latex-base
sudo apt install texlive-latex-recommended
sudo apt install texlive-fonts-recommended
sudo apt install texlive-latex-extra

#needed for ssh
sudo apt install ssh-askpass

#needed to export org docs to pdfs
sudo apt install texlive-full

#needed to use pdf-tools layer
sudo apt install libpng-dev zlib1g-dev libpoppler-glib-dev libpoppler-private-dev
