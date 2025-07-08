#!/usr/bin/python3
# -*- coding: UTF-8, tab-width: 4 -*-

import socket
import sys

MAX_MSG_LEN = 16
MAX_CMSG_LEN = 256
UDS_SOCK_TYPE= (socket.AF_UNIX, socket.SOCK_STREAM,)

src_path = sys.argv[1]
dest_fdnum = sys.stdout.fileno()

conn = socket.socket(*UDS_SOCK_TYPE)
conn.connect(src_path)
msg, ancdata, flags, addr = conn.recvmsg(MAX_MSG_LEN, MAX_CMSG_LEN)
# print('took message', *[repr(x) for x in (msg, ancdata, flags, addr,)])
with socket.fromfd(dest_fdnum, *UDS_SOCK_TYPE) as dest_sock:
    dest_sock.sendmsg([msg], ancdata)
