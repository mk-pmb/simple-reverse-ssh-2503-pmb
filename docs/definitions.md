
Definitions
===========

* A "__drone__" is a remote machine offering contact to its SSH server.
  * By extension, it also means a specific connection attempt from that drone,
    e.g. "dropping a drone" means to close the connection.

* The "__usher__" is the server program that receives and manages incoming
  drone connections.

* A "__hive__" is a subdirectory in the repo toplevel whose name is a number.
  It's the port number that your drone will send in its `CONNECT` request.

* A "__chamber__" is a subdirectory inside the hive.
  The hostname given in the `CONNECT` request is split into the labels,
  the list is reversed, and used as path prefix for the session files
  (see example below).

* The "__connection base filename__", short "__CBFN__", is a path prefix
  used to save files related to a specific drone connection.

* The "__drone badge name__" is the hostname-like string that a drone uses
  to identify itself when it connects.
  The "badge" part is meant as in wearing a name badge.

* The "__SSH remote name__" for reverse SSH connections is the destination
  hostname that the usher tells the SSH client it would be connecting to.
  By default it's the same as the drone badge name, but the usher may be
  configured to transform it, e.g. for simplification or unification.




