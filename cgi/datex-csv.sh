#!/bin/bash

#
#  datex-csv.sh - textual database library (CSV format)
#
#  Copyright (c) 2020 Flavio Augusto (@facmachado)
#
#  This software may be modified and distributed under the terms
#  of the MIT license. See the LICENSE file for details.
#
#  Usage: source datex-csv.sh
#

#
# Arquivo declarado em variável obrigatório
#
if test -z "$DBFILE"; then
  echo "Declare filename in variable DBFILE" >&2
  return 1
fi
if ! test -r "$DBFILE" -a -w  "$DBFILE"; then
  echo "File $DBFILE is unavailable" >&2
  return 1
fi

#
# Constantes iniciais
#
#name=$(basename "${0%.*}")
#tempfile="/tmp/$name-$(date +%s).tmp"
sep=,

#
# Gera um cabeçalho CSV com os campos informados como parâmetros
# @param {string} field
# @param {string} field
# ...
# @returns {string}
#
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

#
# Gera um identificador de registro (ID)
# @returns {number}
#
function create_id() {
  grep -c '' "$DBFILE"
}

#
# Mostra o cabeçalho
# @returns {string}
#
function show_header() {
  grep -m1 "^id${sep}.*${sep}ins${sep}upd${sep}del$" "$DBFILE"
}

#
# Mostra o registro informado (no formato CSV)
# @param {number} id
# @returns {string}
#
function show_row() {
  grep -m1 "^$1$sep" "$DBFILE"
}

#
# Aguarda o arquivo ser liberado para escrita
#
function wait_write() {
  while lsof "$(readlink -f "$DBFILE")"; do :; done
}

#
# Lista os registros não apagados (no formato chave=valor)
# @param {number} start
# @param {number} quantity
# @returns {string}
#
function list_records() {
  if test -z "$*"; then
    echo 'Put the start id and the quantity of records' >&2
    return 1
  fi

  for ((r=$1; r<$1+$2; r++)); do
    select_record "$r" 2>/dev/null | grep -v 'del=1'
  done
}

#
# Cria um novo registro
# @param {string} field=value
# @param {string} field=value
# ...
#
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
      if [[ $key == "${header[i]}" ]]; then
        [[ $val =~ ^[0-9-]+$ ]] &&  \
          row+="${val}${sep}"   ||  \
          row+="\"${val}\"${sep}"
      fi
    done
  done
  now="$(date +%s)${sep}"
  row+="${now}${now}0"

  wait_write && echo "$row" >>"$DBFILE"
}

#
# Mostra o registro informado (no formato chave=valor)
# @param {number} id
# @returns {string}
#
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
    data+="${header[i]}=${row[i]} "
  done

  echo "${data:0:-1}"
}

#
# Modifica os dados do registro informado
# Ex: update_record 3 nome='Testa de Ferro' obs='Teste de Brasa'
# @param {number} id
# @param {string} field=value
# @param {string} field=value
# ...
#
function update_record() {
  if (($1 == 0)); then
    echo 'Value of primary key must start from 1' >&2
    return 1
  fi
  if ! show_row "$1" >/dev/null; then
    echo "Record $1 not found" >&2
    return 1
  fi

  local -i now
  local new old
  now=$(date +%s)
  old=$(show_row "$1")

  IFS=$sep
  read -r -a header < <(show_header)
  read -r -a row <<<"$old"
  read -r -a data <<<"${*:2}${sep}upd=${now}" # <-- FIXME: Ordenar campos

  for ((i=0; i<${#header[@]}; i++)); do
    if [[ ${data[i]/=*/} == ${header[i]} ]]; then
      [[ ${data[i]/*=/} =~ ^[0-9-]+$ ]] &&  \
        new+="${data[i]/*=/}${sep}"     ||  \
        new+="\"${data[i]/*=/}\"${sep}"
    else
      new+="${row[i]}${sep}"
      data=(0=0 ${data[@]})
    fi
  done

  wait_write && sed -i "s/^$old$/${new:0:-1}/" "$DBFILE"
}

#
# "Apaga" o registro (marca para recuperação ou exclusão definitiva)
# @param {number} id
#
function delete_record() {
  if (($1 == 0)); then
    echo 'Value of primary key must start from 1' >&2
    return 1
  fi
  if ! show_row "$1" >/dev/null; then
    echo "Record $1 not found" >&2
    return 1
  fi

  local -i now
  local new old
  now=$(date +%s)
  old=$(show_row "$1")
  new=$(sed -E "s/${sep}[0-9]+${sep}0$/${sep}${now}${sep}1/" <<<"$old")

  wait_write && sed -i "s/^$old$/$new/" "$DBFILE"
}
