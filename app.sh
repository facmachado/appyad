#!/bin/bash

#
# shellcheck disable=SC1091
#

#
#  Copyright (C) 2020 Flavio Augusto (@facmachado)
#
#  This software may be modified and distributed under the terms
#  of the MIT license. See the LICENSE file for details.
#

#
# Declare some vars
#
YAD=$(command -v yad)
# THIS=$(basename "$0")

#
# Check some dependencies
#
if [ ! "$YAD" ]; then
  echo 'Error: YAD not installed' >&2
  exit 1
fi

source lib/app.conf
source lib/window.sh

win_main "$@" 2>/dev/null
