#!/bin/bash

#
#  sqlite3json.sh
#
#  Copyright (c) 2020 Flavio Augusto (@facmachado)
#
#  This software may be modified and distributed under the terms
#  of the MIT license. See the LICENSE file for details.
#
#  Usage: source sqlite3json.sh
#

#
# Arquivo declarado em variável obrigatório
#
# if test -z "$DBFILE"; then
#   echo "Declare filename in variable DBFILE" >&2
#   return 1
# fi
# if ! test -r "$DBFILE" -a -w  "$DBFILE"; then
#   echo "File $DBFILE is unavailable" >&2
#   return 1
# fi

#
# Constantes iniciais
#
#name=$(basename "${0%.*}")


# -----------------------------------------------------------------------------

function output_json() {
  awk -f "$(dirname ${BASH_SOURCE})/output_json.awk"
}

# -----------------------------------------------------------------------------

# jq -> validará a entrada de json e pegará os dados importantes para enviar
#       para o sqlite
# sqlite + json -> retornará a saída pertinente de json

function query_sql() {
  data=$(sqlite3 -line $DBFILE "$1")
  if grep '(select|pragma table_info)' <<<"$1"; then
    :
  else
    :
  fi
}


# -----------------------------------------------------------------------------


#
# Lista os registros não apagados
#
function list_records() {
  :
}

#
# Cria um novo registro
#
function insert_record() {
  :
}

#
# Mostra o registro informado
#
function select_record() {
  :
}

#
# Modifica os dados do registro informado
#
function update_record() {
  :
}

#
# "Apaga" o registro (marca para recuperação ou exclusão definitiva)
#
function delete_record() {
  :
}
