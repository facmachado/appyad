#!/bin/bash

#
#  asciibit.sh - ASCII strings functions library
#
#  Copyright (c) 2020 Flavio Augusto (@facmachado)
#
#  This software may be modified and distributed under the terms
#  of the MIT license. See the LICENSE file for details.
#
#  Usage: source asciibit.sh
#

#
# Converte de string ASCII para string binária (0 ou 1)
# @param {string} input
# @returns {string}
#
function ascii2b() {
  printf %s "$1" | xxd -b | cut -d' ' -f2-7 | tr -d ' \n'
}

#
# Converte de string ASCII para string HEX
# (letras minúsculas, sem prefixo/sulfixo x ou h)
# @param {string} input
# @returns {string}
#
function ascii2x() {
  printf %s "$1" | xxd -p | tr -d \\n
}

#
# Converte de string binária (0 ou 1) para string ASCII
# @param {string} input
# @returns {string}
#
function b2ascii() {
  local data pad size
  size=$(printf %s "$1" | wc -c)
  ((size % 8 < 1)) && pad=0 || pad=$((8 - size % 8))
  ((pad > 0)) && data="$(printf %0${pad}g 0)$1" || data=$1

  x2ascii "$(bc <<<"obase=16; ibase=2; $data" | tr '[:upper:]' '[:lower:]' | tr -d \\n)"
}

#
# Converte de string HEX (sem prefixo/sulfixo x ou h) para string ASCII
# @param {string} input
# @returns {string}
#
function x2ascii() {
  local data pad size
  size=$(printf %s "$1" | wc -c)
  ((size % 2 < 1)) && pad=0 || pad=$((2 - size % 2))
  ((pad > 0)) && data="$(printf %0${pad}g 0)$1" || data=$1

  xxd -r -p <<<"$data"
}
