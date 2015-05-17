## Kenta Hasui
## CS 377: Spring 2015
## Assignment 6: Single Buffer Server

require 'rinda/tuplespace'

## URI = "druby://localhost:67671"
URI = "druby://:4000"
DRb.start_service(URI, Rinda::TupleSpace.new)

ts = Rinda::TupleSpaceProxy.new(DRbObject.new(nil, URI))
localArraySize = 20
ts.write([:Size, localArraySize])
ts.write([:Sem, :Empty])
puts "Wrote empty semaphore to tuple space"

DRb.thread.join
