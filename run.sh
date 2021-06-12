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

here="$(pwd)"
rand="$(expr 9999999 + $RANDOM)"
"$(dirname $0)"/watch.sh "$rand" &
watch="$(ps -ewww -o pid,command | sed -e 's/^  *// ; /grep/ d ; /watch\.sh/ s/ .*// ; / / d')"
echo "watch is at $watch"
trap ctrl_c INT
function ctrl_c() {
    echo ctrl/c - killing watch at $watch
    kill $watch
    exit
}
sleep 3
while true ; do
    swift run --sanitize=address
    sts=$?
    if [ $sts -ne 0 ] ; then
        echo "result of run was $sts"
        echo "error - waiting for another file change"
        sh -c "sleep $rand"
    fi
    sleep 3
done
