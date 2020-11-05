#!/usr/bin/awk -f

#
#  Copyright (c) 2020 Flavio Augusto (@facmachado)
#
#  This software may be modified and distributed under the terms
#  of the MIT license. See the LICENSE file for details.
#

function output() {
  if (n++ && line) {
    printf ","
  }
  if (line) {
    print line
  }
  line = ""
}

function trim(x) {
  sub(/^ */, "", x)
  sub(/ *$/, "", x)
  return x
}

BEGIN {
}

NF == 0 {
  output()
  next
}

{
  if (line) {
    line = line ","
  }
  i = index($0, "=")
  value = substr($0, i + 2)
  line = line value
}

END {
  output()
}
