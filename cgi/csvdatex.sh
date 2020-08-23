#!/bin/bash

#
#  Copyright (c) 2020 Flavio Augusto (@facmachado)
#
#  This software may be modified and distributed under the terms
#  of the MIT license. See the LICENSE file for details.
#


name=$(basename "${0%.*}")
tempfile="/tmp/$name-$(date +%s).tmp"
#mask=·
sep=,

if test -z "$DBFILE"; then
  echo "Declare filename in variable DBFILE" >&2
  return 1
fi
if ! test -r "$DBFILE" -a -w  "$DBFILE"; then
  echo "File $DBFILE is unavailable" >&2
  return 2
fi
if ! grep -qm1 "^id$sep" "$DBFILE"; then
  echo "Header was not found in file $DBFILE" >&2
  return 43
fi


function has_key() {
  grep -qi "^$1$sep" "$DBFILE"
}

#function sep_mask() {
#  sed "s/$sep/$mask/"
#}

#function sep_unmask() {
#  sed "s/$mask/$sep/"
#}

function show_fields() {
  grep -m1 "^id$sep" "$DBFILE"
}

function urldecode() {
  local coded="${1//+/ }"
  printf %b "${coded//%/\\x}"
}

function urlencode() {
  local offset

  for ((i=0; i<${#1}; i++)); do
    offset="${1:i:1}"

    case "$offset" in
      [a-zA-Z0-9.~_-])
        printf %s "$offset"
      ;;
      ' ')
        printf +
      ;;
      *)
        printf %%%X "'$offset"
      ;;
    esac
  done
}

#function wait_write() {
#  while lsof "$(readlink -f "$DBFILE")"; do
#    sleep 0.1
#  done
#}


#function insert_record() {}

function select_record() {
  local data
  IFS="$sep"

  read -r -a fields < <(show_fields)
  read -r -a records < <(grep -m1 "^$1$sep" "$DBFILE")
  for ((i=0; i<${#fields[@]}; i++)); do
    data+="${fields[$i]}=$(urlencode "${records[$i]}")&"
  done
  echo "${data:0:-1}"
}

#function update_record() {}

#function delete_record() {}
