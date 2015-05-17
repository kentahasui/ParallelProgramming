## Kenta Hasui
## CS377: Spring 2015
## Assignment 6: Bounded Buffer Consumer

require 'rinda/rinda'

URI = "druby://localhost:67671"
DRb.start_service 

class Consumer
	def initialize(id)
		@ts = Rinda::TupleSpaceProxy.new(DRbObject.new(nil, URI))
		@id = id
		# Get the size of the buffer from shared memory (tuple space)
		name, @BufferSize = @ts.take([:N, Numeric])
		# Release lock for accessing the size, so other objects can access it
		@ts.write([:N, @BufferSize])
		# Create a new array
		@localBuffer = Array.new(@BufferSize)
		# Pointer to the next value to consume from
		@front = 0
	end

	def run
		# run forever
		while true do
			sleep rand(0)
			#P(full)
			puts "Consumer #{@id} waiting on full"
			@ts.take([:Sem, :Full])
			# Retrieve data from shared memory
			tupleName, index, data = @ts.take([:Buffer, @front, Numeric])
			# Place data into local buffer
			@localBuffer[@front] = data
			puts "Consumer #{@id} retrieved datum #{data} and placed it in its local buffer at position #{index}"
			@front = (@front+1) % @BufferSize
			# V(empty)
			@ts.write([:Sem, :Empty])
			puts "Consumer #{@id} signals empty"
		end
	end
end

cons1 = Consumer.new(0)
cons1.run
