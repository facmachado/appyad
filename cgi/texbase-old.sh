#!/bin/bash

#
#  Copyright (c) 2020 Flavio Augusto (@facmachado)
#
#  This software may be modified and distributed under the terms
#  of the MIT license. See the LICENSE file for details.
#


readonly name=$(basename "${0%.*}")
readonly tempfile="/tmp/$name-$(date +%s).tmp"

if test -z "$DBFILE"; then
  echo "Error: Database not informed" >&2
  return 1
fi

if ! test -r "$DBFILE" -a -w  "$DBFILE"; then
  echo "Error: Database not available" >&2
  return 1
fi


SEP=:
MASK=·

function wait_write() {
  while lsof "$(readlink -f "$DBFILE")"; do
    sleep 0.1
  done
}

function sep_mask() {
  tr $SEP $MASK
}

function sep_unmask() {
  tr $MASK $SEP
}

function has_key() {
  grep -qi "^$1$SEP" "$DBFILE"
}

function get_field() {
  local key=${2:-.*}

  grep -i "^$key$SEP" "$DBFILE" | cut -d $SEP -f $1 | sep_unmask
}

function show_fields() {
  head -1 "$DBFILE" | tr $SEP \\n
}


function insert_record() {
  local key=$(echo "$1" | cut -d $SEP -f1)

  if has_key "$key"; then
    return 1
  fi
  wait_write
  echo "$*" >>"$DBFILE"
  return 0
}

function select_record() {
  local data=$(grep -i "^$1$SEP" "$DBFILE")
  local i=0

  if test -z "$data"; then
    return 1
  fi
  show_fields | while read field; do
    i=$((i + 1))
    printf '%s\n' "$field: $data" | cut -d $SEP -f $i | sep_unmask
  done
  return 0
}

function delete_record() {
  if ! has_key "$1"; then
    return 1
  fi
  grep -vi "^$1$SEP" "$DBFILE" >"$tempfile"
  wait_write
  mv "$tempfile" "$DBFILE"
  return 0
}


#function has_key() {
#  grep -qi "^$1$sep" "$DBFILE"
#}


#function delim_mask() {
#  sed "s/$delim/$mask/"
#}

#function delim_unmask() {
#  sed "s/$mask/$delim/"
#}


#function urldecode() {
#  local coded="${1//+/ }"
#
#  printf %b "${coded//%/\\x}"
#}

#function urlencode() {
#  local offset
#
#  for ((i=0; i<${#1}; i++)); do
#    offset="${1:i:1}"
#
#    case "$offset" in
#      [a-zA-Z0-9.~_-])
#        printf %s "$offset"
#      ;;
#      ' ')
#        printf +
#      ;;
#      *)
#        printf %%%X "'$offset"
#      ;;
#    esac
#  done
#}

#if ! grep -qm1 ^id, "$DBFILE"; then
#  echo "Header was not found in file $DBFILE" >&2
#  return 1
#fi
