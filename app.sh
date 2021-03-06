#!/bin/bash

#
#  Copyright (c) 2020 Flavio Augusto (@facmachado)
#
#  This software may be modified and distributed under the terms
#  of the MIT license. See the LICENSE file for details.
#


readonly name=$(basename "${0%.*}")
readonly pidfile="/run/user/$UID/$name-$(date +%s).pid"
readonly python=$(command -v python3)
readonly yad=$(command -v yad)

if test -z "$python" -o -z "$yad"; then
  echo "Error: YAD and Python 3 not installed or not found in your PATH" >&2
  exit 1
fi


readonly index='public/index.html'
readonly host='127.0.0.1'
readonly port=65432


function do_exit() {
  pkill -SIGTERM -F "$pidfile" && \
  rm -f "$pidfile"
  exit 0
}


trap do_exit SIGINT
trap do_exit SIGTERM

$python httpd.py 2>/dev/null & echo $! >"$pidfile"

$yad --width=640 --height=480 --maximized --no-buttons  \
  --no-escape --borders=0 --window-icon='favicon.ico'   \
  --html --browser --uri="http://$host:$port/$index"    \
  2>/dev/null

do_exit
