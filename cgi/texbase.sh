#!/bin/bash

#
#  Copyright (c) 2020 Flavio Augusto (@facmachado)
#
#  This software may be modified and distributed under the terms
#  of the MIT license. See the LICENSE file for details.
#


name=$(basename "${0%.*}")
tempfile="/tmp/$name-$(date +%s).tmp"
sep=,

if test -z "$DBFILE"; then
  echo "Declare filename in variable DBFILE" >&2
  return 1
fi
if ! test -r "$DBFILE" -a -w  "$DBFILE"; then
  echo "File $DBFILE is unavailable" >&2
  return 1
fi
if ! grep -qn1 "^id$sep" "$DBFILE"; then
  echo "Header was not found in file $DBFILE" >&2
  return 1
fi


function wait_write() {
  while lsof "$(readlink -f "$DBFILE")"; do
    sleep 0.1
  done
}




function insert_record() {}

function select_record() {}

function update_record() {}

function delete_record() {}
