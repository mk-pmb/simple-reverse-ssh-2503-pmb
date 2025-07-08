#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function usher_negotiate () {
  # Our stdin is /dev/null from the re-exec, so we need to re-establish it.
  # Fortunately, our stdout survived the re-exec, and it's the same socket.
  exec <&1

  # Debug stuff:
  # ls -lF -- /proc/$$/fd/* >&2
  # local -p >&2
  # ps hu $PPID $$ >&2
  # pstree-up $$ >&2
  # env | sort -V >&2
  # usher_debug_list_socat_sockets >&2

  local REQ_HOST= REQ_PORT= SESS_DIR=
  usher_read_http_request || return 0
  usher_find_create_session_directory || return 0
  local SESS_BFN="$(printf '%(%y%m%d-%H%M%S)T' -1)-$PPID"
  local SESS_SOCK="$SESS_DIR/$SESS_BFN.sock"


}













return 0
