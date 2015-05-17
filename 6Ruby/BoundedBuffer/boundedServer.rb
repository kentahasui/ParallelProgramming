## Kenta Hasui
## CS377: Spring 2015
## Assignment 6: Bounded Buffer server
require 'rinda/tuplespace'
require 'rinda/rinda'

URI = "druby://localhost:67671"
DRb.start_service(URI, Rinda::TupleSpace.new)

ts = Rinda::TupleSpaceProxy.new(DRbObject.new(nil, URI))
size = 20
ts.write([:N, size])
(0..size-1).each do |i|
	ts.write([:Sem, :Empty])
end
puts "Wrote #{size} values of empty semaphore to tuple space"

DRb.thread.join
