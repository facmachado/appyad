#!/usr/bin/awk -f

#
#  Copyright (c) 2020 Flavio Augusto (@facmachado)
#
#  This software may be modified and distributed under the terms
#  of the MIT license. See the LICENSE file for details.
#

BEGIN {
  FS = ","
}

BEGINFILE {
  total = 0
  now = systime()
  while (getline <FILENAME) {
    total++
  }
}

NR == 1 {
  for (i = 1; i <= NF; i++) {
    col[$i] = ""
    for (j = 0; j < ARGC; j++) {
      if (ARGV[j] ~ "=") {
        key = ARGV[j]
        value = ARGV[j]
        sub(/=.*$/, "", key)
        sub(/^.*=/, "", value)
        if (key == $i) {
          col[$i] = value
        }
      }
    }
  }
  col["del"] = 0
  col["ins"] = now
  col["upd"] = now
  col["id"] = total
  for (i = 1; i <= NF; i++) {
    line = line $i " = " col[$i] "\n"
  }
}

END {
  print substr(line, 1, length(line) - 1)
}
