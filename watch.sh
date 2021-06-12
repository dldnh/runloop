#!/bin/bash

# MIT License
# 
# Copyright (c) 2021 Dave Diamond
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

exe="$(find .build -name Run)"
rand="$1"
last=""
while true ; do
    file="$(find Package.swift Sources -name \*.swift -and -not -name .#\* -print0 | xargs -0 ls -td | head -1)"
    curr="$(ls -l "$file")"
    if [ "$last" = "" ] ; then
        last="$curr"
    fi
    if [ "$last" != "$curr" ] ; then
        last="$curr"
        echo "$file has changed"
        pid="$(ps -ewww -o pid,command | sed -e 's/^  *// ; /grep/ d ; /sleep '"$rand"'/ s/ .*// ; \#'"$exe"'# s/ .*// ; / / d')"
        kill -INT "$pid"
    fi
    sleep 3
done
