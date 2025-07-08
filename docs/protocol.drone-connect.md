
Drone connect protocol
======================

* This document uses [these definitions](definitions.md).


In order to use the HTTP CONNECT mechanisms that ship with netcat, socat
and many similar popular tools, we expect a drone greeting that looks like
a HTTP CONNECT request, for example: `CONNECT slab01.example.edu:1 HTTP/1.1`

* A potential trailing U+000D carriage return character will be ignored.
* The first letter of the CONNECT hostname gives the connection mode.
* The port number is used as the hive number. The usher is probably more
  lenient about the number range than the drone's socat-like tool.


Connection modes
----------------

* `s` = Reverse SSH connection. Whoever accepts it (i.e. the usher),
  should expect to receive the SSH server's greeting.
* `o` = Offering some opaque general-purpose TCP thingy.
  Meant for a generic rendezvous service.
* `i` = Request for immediate contact to any available homonymous
  `o`-mode connection.
* `l` = Lurking variant of `i` mode, potentially waiting until a suitable
  connection is available.
  * There is no guarantee for a priority queue, so in a race condition
    with other connections, others may win. In extreme cases, the
    `l`-mode connection may effectively be starved.
* All other mode characters are reserved for future use.










