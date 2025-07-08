#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function usher_read_http_request () {
  local VAL= AUX=
  read -rs -t 10 VAL || return 2$(echo E: 'No request was received.' >&2)
  VAL="${VAL%$'\r'}"
  case "$VAL" in
    'CONNECT '*:*' HTTP/'[01].[01] ) ;;
    * ) echo E: "Bad request line: '$VAL')" >&2; return 2;;
  esac
  VAL="${VAL#* }"
  VAL="${VAL% *}"

  AUX="$(usher_validate_hostname_nofinaldot_colon_port "$VAL")"
  [ -z "$AUX" ] || return 2$(
    echo E: "Bad host/port for CONNECT: $AUX" >&2)

  REQ_HOST="${VAL%:*}"
  REQ_PORT="${VAL##*:}"
  echo D: "Valid request for hive $REQ_PORT chamber '$REQ_HOST'." >&2
  while read -rs -t 10 VAL; do
    VAL="${VAL%$'\r'}"
    [ -n "$VAL" ] || return 0
    echo D: "HTTP request header: '$VAL'" >&2
  done
  echo E: 'Incomplete HTTP request.' >&2
  return 2
}






return 0
