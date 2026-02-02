#!/bin/sh

cfile=/usr/local/bin/ed

if [ -L "$cfile" ] && [ -e "$cfile" ]; then
    exit 0
fi

sudo ln -sf /usr/bin/nano /usr/local/bin/ed
