#!/bin/sh
#install gdrive https://github.com/glotlabs/gdrive
GD3_VER=$(curl -s "https://api.github.com/repos/glotlabs/gdrive/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
curl -Lo gdrive_linux-x64.tar.gz "https://github.com/glotlabs/gdrive/releases/download/${GD3_VER}/gdrive_linux-x64.tar.gz"
tar -xvf gdrive_linux-x64.tar.gz ; sudo mv -vf gdrive /usr/local/bin ; rm -v gdrive_linux-x64.tar.gz 
