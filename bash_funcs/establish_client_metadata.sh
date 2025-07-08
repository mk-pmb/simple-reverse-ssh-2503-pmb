#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function usher_establish_client_metadata () {
  exec 2> >(ts "%F %T [$$]" >&2)
  local ENV_PFX=
  read -d '' -rs ENV_PFX <"/proc/$PPID/cmdline"
  ENV_PFX="${ENV_PFX^^}_"
  ENV_PFX="${ENV_PFX//[^A-Z0-9_-]/}"
  eval "$(env |
    sed -nre 's~\x27~~g; s~$~\x27~; s~^'"$ENV_PFX"'([A-Z]+)=~\1=\x27~p' |
    sed -nre 's~^SOCK~ LSN_~; s~^PEER~ DRONE_~; s~^ ~export ~p')"
  unset -- $(env | cut -d = -sf 1 | sed -nre "/^$ENV_PFX/p")
  echo D: "Drone $DRONE_ADDR:$DRONE_PORT connected to $LSN_ADDR:$LSN_PORT" >&2
  exec -a "${CFG[process_alias_prefix]}negotiate" \
    ${CFG[ghciu_reexec]} usher_negotiate \
    "$LSN_ADDR:$LSN_PORT" "$DRONE_ADDR:$DRONE_PORT" \
    || return $?$(echo E: "Failed to re-exec for negotiate" >&2)
}













return 0
