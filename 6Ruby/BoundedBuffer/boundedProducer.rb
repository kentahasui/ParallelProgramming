## Kenta Hasui
## CS377: Spring 2015
## Assignment 6: Bounded Buffer Producer

require 'rinda/rinda'
URI = "druby://localhost:67671"
DRb.start_service 

class Producer
	def initialize(id)
		@ts = Rinda::TupleSpaceProxy.new(DRbObject.new(nil, URI))
		@id = id
		# Get the size of the shared buffer from the tuple space
		name, @BufferSize = @ts.read([:N, Numeric])
		# Initialize the local buffer and fill with random numbers
		@localBuffer = Array.new(@BufferSize)
		# Pointer to the back of the shared buffer
		@rear = 0
	end

	def run
		# run forever
		while true do
			# Fill local buffer with random values
			if @rear == 0
				for index in (0..(@BufferSize-1))
					@localBuffer[index] = rand(100)
				end
			end
			sleep rand(0)
			# retrieve data from local buffer (produce data)
			data = @localBuffer.at(@rear)
			# P(empty)
			puts "Producer #{@id} waiting on empty"
			@ts.take([:Sem, :Empty])
			# Produce data
			@ts.write([:Buffer, @rear, data])
			puts "Producer #{@id} placed datum #{data} into buffer at index #{@rear}"
		  @rear = (@rear + 1)% (@BufferSize)
			# V(full)
			@ts.write([:Sem, :Full])
			puts "Producer #{@id} signals full"
		end
	end
end

prod1 = Producer.new(0)
prod1.run
