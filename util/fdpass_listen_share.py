#!/usr/bin/python3
# -*- coding: UTF-8, tab-width: 4 -*-

import array
import os
import socket
import sys


NATIVE_FD_NUM_TYPE = 'i' # int


def main():
    share_fdnum = sys.stdin.fileno()
    lsn_path = sys.argv[1]
    lsn_path = lsn_path.replace('|', str(os.getpid()))

    lsn_sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    try:
        os.remove(lsn_path)
    except FileNotFoundError:
        pass
    lsn_sock.bind(lsn_path)
    lsn_sock.listen(1)
    try:
        conn, addr = lsn_sock.accept()
        # addr will be the empty string even if running as root.
    except KeyboardInterrupt:
        return

    lsn_sock.close()
    os.remove(lsn_path)

    dummy_message = b'\0'
    messages = [dummy_message]
    fdpass_control_message = (
      socket.SOL_SOCKET,
      socket.SCM_RIGHTS,
      array.array(NATIVE_FD_NUM_TYPE , (share_fdnum,)),
      )
    ancillary_data = [fdpass_control_message]
    conn.sendmsg(messages, ancillary_data)
    conn.close()


main()
