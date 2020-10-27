#!/usr/bin/awk

#
#  Copyright (c) 2020 Flavio Augusto (@facmachado)
#
#  This software may be modified and distributed under the terms
#  of the MIT license. See the LICENSE file for details.
#
#  Base: https://stackoverflow.com/a/36049307
#

function output() {
  if (n++) {
    print ","
  }
  if (line) {
    print "{" line "}"
  }
  line = ""
}

function trim(x) {
  sub(/^ */, "", x)
  sub(/ *$/, "", x)
  return x
}

BEGIN {
  print "["
}

NF==0 {
  output()
  next
}

{
  if (line) {
    line = line ", "
  }
  i = index($0, "=")
  key = "\"" trim(substr($0, 1, i - 1)) "\""
  if (substr($0, i + 2) ~ /^[0-9]+$/) {
    value = substr($0, i + 2)
  } else {
    value = "\"" substr($0, i + 2) "\""
  }
  line = line key ": " value
}

END {
  output()
  print "]"
}
