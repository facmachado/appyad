#!/bin/bash

#
#  datex.sh - textual database library
#
#  Copyright (c) 2020 Flavio Augusto (@facmachado)
#
#  This software may be modified and distributed under the terms
#  of the MIT license. See the LICENSE file for details.
#
#  Usage: source datex.sh
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

# -----------------------------------------------------------------------------

#
# Lista os registros não apagados (no formato chave = valor)
# @param {number} lines (0 => all)
# @param {number} start = 1
# @returns {string}
#
function list_records() {
  local awkprg
  local -i lines start
  awkprg="$(dirname "${BASH_SOURCE[0]}")/crud_read.awk"
  ((${1:-0} < 1)) && lines=$(($(wc -l <"$DBFILE") - 1)) || lines=$1
  ((${2:-0} > 0)) && start=$2 || start=1

  awk -f "$awkprg"                \
    -v start=$((start + 1))       \
    -v finish=$((start + lines))  \
    "$DBFILE"
}

#
# Busca por palavra-chave nos registros
# @param {string} query
# @returns {string}
#
function search_records() {
  local awkprg
  awkprg="$(dirname "${BASH_SOURCE[0]}")/crud_read.awk"

  test "$1" && awk -f "$awkprg"  \
    -v query="$1"                \
    "$DBFILE"
}

#
# Mostra o registro requisitado
# @param {number} line
# @returns {string}
#
function select_record() {
  ((${1:-0} > 0)) && list_records 1 "$1"
}

# -----------------------------------------------------------------------------

#
# Cria um novo registro
# @param {string} field=value
# @param {string} field=value
# ...
#
function insert_record() {
  # IFS=$sep
  # local key now row val
  # read -r -a header < <(show_header)
  # read -r -a params <<<"$*"
  #
  # row="$(create_id)${sep}"
  # for ((i=0; i<${#header[@]}; i++)); do
  #   for param in "${params[@]}"; do
  #     key="${param/=*/}"
  #     val="${param/*=/}"
  #     if [[ $key == "${header[i]}" ]]; then
  #       [[ $val =~ ^[0-9-]+$ ]] &&  \
  #         row+="${val}${sep}"   ||  \
  #         row+="\"${val}\"${sep}"
  #     fi
  #   done
  # done
  # now="$(date +%s)${sep}"
  # row+="${now}${now}0"
  #
  # wait_write && echo "$row" >>"$DBFILE"

  # entra => field=value field=value field=value ... (input)
  # entra => field,field,field, ... (csv) (awk)
  # processa => (awk)
  # sai => field = value \n field = value \n field = value \n ... (record)

  local awkprg
  awkprg="$(dirname "${BASH_SOURCE[0]}")/crud_create.awk"

  # test "$*" && \
  awk -f "$awkprg" "$DBFILE" "$@"
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
# "Apaga" o registro (marca para possível recuperação)
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
