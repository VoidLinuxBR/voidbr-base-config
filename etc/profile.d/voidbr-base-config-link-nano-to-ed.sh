#!/bin/sh

cfile=/usr/local/bin/ed
[ -L "$cfile" ] && [ -e "$cfile" ] && return 0
sudo ln -sf /usr/bin/nano /usr/local/bin/ed 2>/dev/null || :
