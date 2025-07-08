
Setup
=====

* This document uses [these definitions](definitions.md).


Creating a hive and a chamber
-----------------------------

#### Session directory path example

For a drone requesting `CONNECT slab01.example.edu:1 HTTP/1.1`,
served by a socat child process with process ID 8899,
connected on 2025-03-18, 14:27:51 UTC, the will be
`1/edu/example/lab01/250318-142751-8899`.

Note that the initial "s" from the hostname is consumed for the mode,
as described in [the drone connect protocol](drone-connect-protocol.md).

* `$CBFN.sock` will be the SSH master control socket.
* `$CBFN.login.log` will be a log file
  for messages that the SSH client may generate while connecting.
  If the SSH login attempt seems to succeed
  and the control socket seems to survive for a few seconds,
  the logfile will be auto-deleted.
* `$CBFN.fdpass.tmp` will be a temporary handover socket used to provide the
  fdpass proxy program with the socket we got from socat.
  This is required because the SSH client will close all inherited sockets,
  meaning the fdpass proxy invoked by the SSH client won't be able to just
  inherit the socat socket.
* For SSH client config purposes and private key selection,
  the usher will construct a fake hostname and tell the SSH client
  we're trying to connect there.
  The fake hostname consists of the hostname from connect, verbatim,
  followed by a configurable suffix that may include the hive number.
  * The config setting for that suffix is named `drone_hostname_suffix`
    and defaults to `.#.hive.alt`.
    * (TLD `.alt` is unresolvable except for local testing, see RFC 9476.)
    * If a more specific config setting `drone_hostname_suffix:$HIVE_NUMBER`
      is defined, it takes precedence.
    * Any `#` character in the suffix will be replaced with the hive number.


#### Missing path segments

* A request for a non-existent hive is unrecoverable, so
  the drone will be considered unauthorized, and dropped.
* For the chamber part though, there is a mechanism to help you host the
  session directories on `tmpfs`: At each directory step in the path,
  if it's a dead symlink, the usher will try and create a directory at the
  symlink target, also creating parent directories if required.
  * Hosting the session directories on tmpfs is especially useful when running
    on a NAS where it would be wasteful to spin up a magnetic disk just to
    create files that after reboot would be useless anyway.
  * However, this comes at the cost of potential memory exhaustion if you use
    an unlimited RAM disk and have evil people on your LAN.
    Thus, consider creating a dedicated, size-limited RAM disk.
* If any part of the path is not a directory
  even after the potential symlink revival attempt,
  the drone will be considered unauthorized, and dropped.







