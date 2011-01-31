JDBC driver for RDBI
====================

This gem gives you the ability to query JDBC connections with RDBI.

Usage
-----

    > gem install rdbi-driver-jdbc
    > irb
    > require 'rdbi-driver-jdbc'
    > dbh = RDBI.connect :JDBC, :db => "MY_DSN", :user => "USERNAME",
    *   :password => "PASSWORD"
    > rs = dbh.execute "SELECT * FROM MY_TABLE"
    > rs.as(:Struct).fetch(:first)
  

Copyright
---------

Copyright (c) 2011 Shane Emmons. See LICENSE for details.
