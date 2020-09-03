#!/bin/bash

#
#  randfunc.sh - random functions library
#
#  Copyright (C) 2020 Flavio Augusto (@facmachado)
#
#  This software may be modified and distributed under the terms
#  of the MIT license. See the LICENSE file for details.
#
#  Usage: source randfunc.sh
#

#
# Gera um número sorteado, baseado na quantidade informada de bilhetes
# (até 18 algarismos) e no tempo de expectativa em segundos.
# Dica: Valor negativo de tempo dá "mais emoção" ao sorteio
# @param {number} quantity
# @param {number} time
# @returns {string}
#
function random_draw() {
  q=$((${1:-1}))
  t=$((${2:-0}))
  d=$(($(printf %s ${q#-} | wc -c)))
  e=$(($(date -ud "${t#-} seconds" +%s)))
  while (($(date -u +%s) <= e)); do
    c=$(($(bc <<<"$(random_hash $d)")))
    s=$((c % q + 1))
    if ((s < 1 || d > 18)); then
      printf '\r\e[1;31mOut of range!\e[0m\n' >&2
      return 1
    else
      ((t < 0)) && printf "\\r%0.${d}d" "$c"
    fi
  done
  printf "\\r%0.${d}d" "$s"
}

#
# Gera um identificador do tipo GUID/UUID. Se disponível,
# usa o uuidgen; do contrário, usa o random_hash
# @returns {string}
#
function random_guid() {
  [ -x "$(command -v uuidgen)" ] &&  \
    uuidgen -r | tr -d \\n &&        \
    return 0
  r=$(random_hash 32 16)
  printf %s "${r:0:8}-${r:8:4}-${r:12:4}-${r:16:4}-${r:20:12}"
}

#
# Gera um número (ou um hash) aleatório
# de base 2 (binário), 8 (octal), 10 (decimal) ou 16 (hexadecimal)
# @param {number} size
# @param {number} radix
# @returns {string}
#
function random_hash() { (
  usage() {
    echo 'Usage: random_hash <size> [2|8|10|16]'
  }
  l=$(($1))
  b=$((${2:-10}))
  ((l < 1)) && usage && return 0
  case $b in
    2)   readonly r='01'                                        ;;
    8)   readonly r='0-7'                                       ;;
    10)  readonly r='0-9'                                       ;;
    16)  readonly r='0-9a-f'                                    ;;
    *)   echo -e "Radix not valid!\\n$(usage)" >&2 && return 1  ;;
  esac
  tr -dc $r </dev/urandom | head -c $l
) }

#
# Gera uma palavra aleatória, com alguns caracteres especiais
# @param {number} max
# @returns {string}
#
function random_word() {
  x=$(($1))
  ((x < 1)) &&                          \
    echo 'Usage: random_word <max>' &&  \
    return 0
  l=$((RANDOM % x + 1))
  tr -dc '[:graph:]' </dev/urandom | head -c $l
}


# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------


#
# Converte uma string hexadecimal em dados binários
# @param {string} hex
# @returns {blob}
#
function hex2asciidata() {
  data=$(tr [:upper:] [:lower:] <<<"$1" | sed 's/^[\0]x//;s/h$//')
  test $((${#data} % 2)) -ne 0 && data=0$data
  xxd -p -r <<<"$data"
}

#
# Converte dados binários em string hexadecimal
# @param {blob} data
# @returns {string}
#
function asciidata2hex() {
  printf %s "$1" | xxd -p | tr -d \\n
}
