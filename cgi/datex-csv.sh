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


name=$(basename "${0%.*}")
tempfile="/tmp/$name-$(date +%s).tmp"
delim='"'
mask='\"'
sep=,

function create_header() {
  if show_header >/dev/null; then
    echo "Header was already created in file $DBFILE" >&2
    return 1
  fi
  if ((${#*} < 1)); then
    echo 'You must enter at least ONE field to create header' >&2
    return 1
  fi

  read -r -a fields <<<"id $* ins upd del"
  wait_write && sed "s/ /$sep/g" <<<"${fields[@]}" >"$DBFILE"
}

function create_id() {
  grep -c '' "$DBFILE"
}

function show_header() {
  grep -m1 "^id${sep}.*${sep}ins${sep}upd${sep}del$" "$DBFILE"
}

function show_row() {
  grep -m1 "^$1$sep" "$DBFILE"
}

function wait_write() {
  while lsof "$(readlink -f "$DBFILE")"; do :; done
}


# list_records(start, limit) { where del == false }

function insert_record() {
  IFS=$sep
  local key now row val
  read -r -a header < <(show_header)
  read -r -a params <<<"$*"

  row="$(create_id)${sep}"
  for ((i=0; i<${#header[@]}; i++)); do
    for param in "${params[@]}"; do
      key="${param/=*/}"
      val="${param/*=/}"
      if [[ $key == "${header[$i]}" ]]; then
        [[ $val =~ ^[0-9-.]+$ ]] &&  \
          row+="${val}${sep}"    ||  \
          row+="\"${val}\"${sep}"
      fi
    done
  done
  now="$(date +%s)${sep}"
  row+="${now}${now}0"

  wait_write && echo "$row" >>"$DBFILE"
}

function select_record() {
  if (($1 == 0)); then
    echo 'Value of primary key must start from 1' >&2
    return 1
  fi
  if ! show_row "$1" >/dev/null; then
    echo "Record $1 not found" >&2
    return 1
  fi

  IFS=$sep
  local data
  read -r -a header < <(show_header)
  read -r -a row < <(show_row "$1")

  for ((i=0; i<${#header[@]}; i++)); do
    test "${header[i]}" == 'del'  \
      -a "${row[i]}" == 1         \
      && return 0
    data+="${header[$i]}=${row[$i]} "
  done

  echo "${data:0:-1}"
}

#function update_record() {}

function delete_record() {
  if (($1 == 0)); then
    echo 'Value of primary key must start from 1' >&2
    return 1
  fi
  if ! show_row "$1" >/dev/null; then
    echo "Record $1 not found" >&2
    return 1
  fi

  local new now old
  now=$(date +%s)
  old=$(show_row "$1")
  new=$(sed -E "s/${sep}[0-9]+${sep}0$/${sep}${now}${sep}1/" <<<"$old")

  wait_write && sed -i "s/^$old$/$new/" "$DBFILE"
}
