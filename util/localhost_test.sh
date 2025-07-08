#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function lhtest_cli_init () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local SELFFILE="$(readlink -m -- "$BASH_SOURCE")"
  local SELFPATH="$(dirname -- "$SELFFILE")"
  local SELFNAME="$(basename -- "$SELFFILE" .sh)"
  cd -- "$SELFPATH" || return $?

  local SSH_SERVER_SPEC='reverse-ssh.example.net'
  local SSH_CLIENT_OPTS=(
    -o BatchMode=yes
    -o ControlPath="tmp.$SELFNAME.%u.%r@%n.%p.mux"
    -o ControlPersist=yes
    -o IdentitiesOnly=yes
    -o ServerAliveInterval=120
    )

  [ "$#" -ge 1 ] || echo H: "Try ./$SELFNAME.sh demo" >&2
  lhtest_"$@"; return $?
}


function lhtest_demo () {
  # Usually, we'd use a service broker as the middleman,
  # but for this demo, we skip that.
  socat TCP:localhost:22 EXEC:"./$SELFNAME.sh master_login"
}


function lhtest_master_login () {
  # The straight-forward approach would be to now duplicate our stdin in
  # order to have the ssh client and the fdpass proxy inherit that, so that
  # the fdpass proxy can give the duplicate of our stdin to the ssh client.
  # Unfortunately, the ssh client is very paranoid and closes all inherited
  # file descriptors. Also while the fdpass proxy can see our stdin in the
  # /proc filesystem, it is unable to access it.
  # Thus we need our own fdpass before we can fdpass to the ssh client.

  local SHARE_SOCK='tmp.handover.|.sock'
  ./fdpass_listen_share.py "$SHARE_SOCK" <&1 &
  local SHARE_PID=$!
  SHARE_SOCK="${SHARE_SOCK//|/$SHARE_PID}"

  SSH_CLIENT_OPTS+=(
    -o ControlMaster=yes
    -o ProxyCommand="./uds_copy_one_msg.py '$SHARE_SOCK'"
    -o ProxyUseFdpass=yes
    -vvv
    )
  # echo D: "ssh ${SSH_CLIENT_OPTS[*]} $SSH_SERVER_SPEC" >&2
  ssh "${SSH_CLIENT_OPTS[@]}" "$SSH_SERVER_SPEC" 64<&0
}











lhtest_cli_init "$@"; exit $?
