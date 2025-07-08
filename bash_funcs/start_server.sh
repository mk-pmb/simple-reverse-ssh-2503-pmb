#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function usher_start_server () {
  local LSN="TCP-LISTEN:${CFG[usher_port]}"
  LSN+=",reuseaddr,fork,${CFG[usher_lsn_opt]}"
  LSN="${LSN%,}"
  local SOCAT_CMD=(
    exec -a "${CFG[process_alias_prefix]}server" \
    socat
    $REVSSH_SOCAT_OPT
    "$LSN"
    EXEC:"${CFG[ghciu_reexec]} usher_establish_client_metadata"
    )

  usher_unset_most_env_vars || return $?$(
    echo E: $FUNCNAME: "Failed to cleanup env vars, rv=$?" >&2)

  "${SOCAT_CMD[@]}" || return $?$(echo E: $FUNCNAME: "Failed (rv=$?) to$(
    printf -- ' ‹%s›' "${SOCAT_CMD[@]}") in $PWD" >&2)
}


function usher_unset_most_env_vars () {
  unset TODO VN # … because they would be hidden by our local variables:
  local TODO="$(env | cut -d = -sf 1 | tr '\n' =)" VN=
  while [ -n "${TODO%=}" ]; do
    VN="${TODO%%=*}"
    TODO="${TODO#*=}"
    case "$VN" in
      [^A-Za-z_]* | *[^A-Za-z0-9_-]* )
        echo E: $FUNCNAME: "Flinching: Scary env var name: '$VN'" >&2
        return 4;;

      HOME | \
      LOGNAME | \
      PATH | \
      REVSSH_* | \
      '' ) continue;; # keep selected essential env vars

      * ) unset "$VN";;
    esac
  done
}






return 0
