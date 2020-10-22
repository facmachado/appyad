#!/bin/bash

#
#  Copyright (c) 2020 Flavio Augusto (@facmachado)
#
#  This software may be modified and distributed under the terms
#  of the MIT license. See the LICENSE file for details.
#

function app_error() {
  cat <<EOF
{
  "action": "unknown",
  "status": "ERROR",
  "code": 255,
  "message": "Unknown error"
}
EOF
}

function table_list() {
  cat <<EOF
{
  "action": "table-list",
  "status": "OK",
  "code": 0,
  "total": 233,
  "data": [{...}, {...}, {...}]
}
EOF
}

function table_search() {
  cat <<EOF
{
  "action": "table-search",
  "status": "OK",
  "code": 0,
  "total": 278,
  "data": [{...}, {...}, {...}]
}
EOF
}

function crud_read() {
  cat <<EOF
{
  "action": "crud-read",
  "status": "OK",
  "code": 0,
  "data": {...}
}
EOF
}

function crud_create() {
  cat <<EOF
{
  "action": "crud-create",
  "status": "OK",
  "code": 0
}
EOF
}

function crud_update() {
  cat <<EOF
{
  "action": "crud-update",
  "status": "OK",
  "code": 0
}
EOF
}

function crud_delete() {
  cat <<EOF
{
  "action": "crud-delete",
  "status": "OK",
  "code": 0
}
EOF
}

function auth_logon() {
  cat <<EOF
{
  "action": "auth-logon",
  "status": "OK",
  "code": 0,
  "_z0": "d512062959c1...",
  "_z1": "14a80769678a..."
}
EOF
}

function auth_logoff() {
  cat <<EOF
{
  "action": "auth-logoff",
  "status": "OK",
  "code": 0
}
EOF
}

function auth_update() {
  cat <<EOF
{
  "action": "auth-update",
  "status": "OK",
  "code": 0
}
EOF
}

function log_read() {
  cat <<EOF
{
  "action": "log-read",
  "status": "OK",
  "code": 0,
  "data": [{...}, {...}, {...}]
}
EOF
}

function config_read() {
  cat <<EOF
{
  "action": "config-read",
  "status": "OK",
  "code": 0,
  "data": {...}
}
EOF
}

function config_update() {
  cat <<EOF
{
  "action": "config-update",
  "status": "OK",
  "code": 0
}
EOF
}

# -----------------------------------------------------------------------------

echo 'Content-Type: application/json'
echo

# uname -a
if [ -z "$QUERY_STRING" ]; then
  app_error
  exit 1
fi

auth_logoff

# $.ajax({
#   type: "GET",
#   url: "/cgi/api.sh",
#   contentType: "application/json",
#   dataType: "json",
#   data: {}
# });
