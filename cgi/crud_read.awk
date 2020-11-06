#!/usr/bin/awk -f

#
#  Copyright (c) 2020 Flavio Augusto (@facmachado)
#
#  This software may be modified and distributed under the terms
#  of the MIT license. See the LICENSE file for details.
#

function parse() {
  for (i = 1; i <= NF; i++) {
    line = line col[i] " = " trim($i)
    if (i < NF) {
      line = line "\n"
    }
  }
  line = line "\n\n"
}

function trim(x) {
  sub(/^\"/, "", x)
  sub(/\"$/, "", x)
  return x
}

BEGIN {
  FS = ","
}

NR == 1 {
  for (i = 1; i <= NF; i++) {
    col[i] = $i
  }
}

NR == start, NR == finish {
  if (start && finish && $NF == 0) {
    parse()
  }
}

$0 ~ query {
  if (query && $NF == 0) {
    parse()
  }
}

END {
  print substr(line, 1, length(line) - 2)
}
