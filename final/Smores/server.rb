## Kenta Hasui
## CS377: Spring 2015
## Final Part 1: Smores
## server.rb
## This file starts up the server for the Smores problem. It also
## initializes the tuple space for the other processes. 
require 'rinda/tuplespace'

## Boilerplate: start the server and create the tuple space
URI = "druby://:4000"
DRb.start_service(URI, Rinda::TupleSpace.new)
## ts = Rinda::TupleSpaceProxy.new(DRbObject.new(nil, URI))
puts "Tuple space initialized"
DRb.thread.join
