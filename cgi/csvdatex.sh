#!/bin/bash

#
#  Copyright (c) 2020 Flavio Augusto (@facmachado)
#
#  This software may be modified and distributed under the terms
#  of the MIT license. See the LICENSE file for details.
#


if test -z "$DBFILE"; then
  echo "Declare filename in variable DBFILE" >&2
  return 1
fi
if ! test -r "$DBFILE" -a -w  "$DBFILE"; then
  echo "File $DBFILE is unavailable" >&2
  return 1
fi
#if ! grep -qm1 ^id, "$DBFILE"; then
#  echo "Header was not found in file $DBFILE" >&2
#  return 1
#fi


name=$(basename "${0%.*}")
tempfile="/tmp/$name-$(date +%s).tmp"
delim='"'
mask='\"'
sep=,

#function has_key() {
#  grep -qi "^$1$sep" "$DBFILE"
#}

function create_header() {
  if show_header >/dev/null; then
    echo "Header was already created in file $DBFILE" >&2
    return 1
  fi
  if ((${#*} < 1)); then
    echo 'You must enter at least ONE field to create header' >&2
    return 1
  fi

  local fields="id $* ins upd del"
  tr ' ' $sep <<<"$fields" >"$DBFILE"
}

function create_id() {
  grep -c '' "$DBFILE"
}

function delim_mask() {
  sed "s/$delim/$mask/"
}

function delim_unmask() {
  sed "s/$mask/$delim/"
}

function show_header() {
  grep -m1 "^id${sep}.*${sep}ins${sep}upd${sep}del$" "$DBFILE"
}

function show_row() {
  grep -m1 "^$1$sep" "$DBFILE"
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


# list_records(start, limit) { where del == false }

function insert_record() {
  IFS=$sep
  local row
  local now
  read -r -a header < <(show_header)
  read -r -a params <<<"$@"

#  echo "${header[@]}"
#  echo "${params[@]}"

  row="$(create_id)${sep}"
  for ((i=0; i<${#header[@]}; i++)); do
    :
  done
  now="$(date +%s)${sep}"
  row+="${now}${now}0"

  echo "$row" #>>"$DBFILE"
}

function select_record() {
  test $1 -eq 0 && return 0
  IFS=$sep
  local data

  read -r -a header < <(show_header)
  read -r -a row < <(show_row $1)
  for ((i=0; i<${#header[@]}; i++)); do
    test "${header[$i]}" == 'del' -a "${row[$i]}" == '1' && return 0
    data+="${header[$i]}=$(urlencode ${row[$i]})&"
  done
  echo "${data:0:-1}"
}

#function update_record() {}

#function delete_record() {}
