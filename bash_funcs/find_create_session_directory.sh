#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function usher_find_create_session_directory () {
  SESS_DIR="$REQ_PORT" # not local!
  local REMAIN=".$REQ_HOST" LABEL=
  [ -d "$REQ_PORT" ] || return 2$(echo E: "No such hive: $REQ_PORT" >&2)
  while [ -n "$REMAIN" ]; do
    LABEL="${REMAIN##*.}"
    REMAIN="${REMAIN%.*}"
    [ -n "$LABEL" ] || continue
    SESS_DIR+="/$LABEL"
    [ -d "$SESS_DIR" ] || [ ! -L "$SESS_DIR" ] ||
      mkdir --parents -- "$(readlink -m -- "$SESS_DIR")" || true
    [ -d "$SESS_DIR" ] && continue
    echo E: "Hive $REQ_PORT doesn't have a chamber '$SESS_DIR'." >&2
    return 2
  done
}






return 0
