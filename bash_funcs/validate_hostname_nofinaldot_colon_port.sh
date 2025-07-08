#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function usher_validate_hostname_nofinaldot_colon_port () {
  local E=
  [ "${#1}" -lt 160 ] || E='address is too long'
  # ^-- The real rules for maximum hostname length are a bit complicated
  #   but for our purposes here we can just pick a sane maximum for the
  #   entire address, including the port number.

  # The upcoming validations don't actually need to properly match RFCs, as
  # we map the address to a file path instead of using it for networking.
  # I was just curious how strict a single `case … in` block could check.
  [ -n "$E" ] || case "$1" in
    '' ) E='empty address';;
    *:*:* ) E='too many ports';;
    *: ) E='no port number';;
    :* ) E='no host name';;
    *:*[^0-9]* ) E='non-digits in port number';;
    *[^A-Za-z0-9._-]*:* ) E='unsupported characters in hostname';;
    .* ) E='hostname must not start with a dot';;
    *..* ) E='hostname contains empty label';;
    *.:* ) E='expected fewer dots at end of hostname';;
    -* | *.-* ) E='hostname labels must not start with a hyphen';;
    *-.* | *-:* ) E='hostname labels must not end with a hyphen';;
    * ) [ "${1##*:}" -le "${CFG[tcp_max_port]}" ] || E='port out of range';;
  esac
  [ -n "$E" ] || return 0
  echo "$E"
  return 2
}






return 0
