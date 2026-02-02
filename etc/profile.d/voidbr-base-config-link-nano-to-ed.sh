#!/bin/sh

cfile=/usr/local/bin/ed

if [ -L "$cfile" ] && [ -e "$cfile" ]; then
    return
fi

sudo ln -sf /usr/bin/nano /usr/local/bin/ed
