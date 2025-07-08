#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function usher_debug_list_socat_sockets () {
  ( ls -lF -- /proc/$$/fd/* | cut -d / -sf 5- |
      sed -nre 's~^(\S+) -> (socket:\S+)$~\2 @ conn fd \1~p'
    ls -lF -- /proc/$PPID/fd/* | cut -d / -sf 5- |
      sed -nre 's~^(\S+) -> (socket:\S+)$~\2 @ server fd \1~p'
  ) 2>/dev/null | tr -d '[]' | sort -V
}






return 0
