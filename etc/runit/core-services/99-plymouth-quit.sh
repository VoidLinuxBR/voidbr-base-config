#!/bin/sh
if command -v plymouth >/dev/null; then
    plymouth quit
fi
