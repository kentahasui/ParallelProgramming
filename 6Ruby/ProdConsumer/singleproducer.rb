## Kenta Hasui
## CS377: Spring2015
## Assignment 6: Single Buffer Producer

require 'rinda/rinda'
URI = "druby://:4000"
DRb.start_service 

class Producer
	def initialize(id)
		@ts = Rinda::TupleSpaceProxy.new(DRbObject.new(nil, URI))
		@id = id
		# Retrieve size of local array from shared memory
		name, @BufferSize = @ts.read([:Size, Numeric])
		# Initialize the local buffer
		@localBuffer = Array.new(@BufferSize)
		# Pointer to the back of the shared buffer			
		@rear = 0
	end

	def run
		#run forever
		while true
			# Fill the local buffer with random values
			if @rear == 0
				for index in (0..(@BufferSize-1))
						@localBuffer[index] = rand(100)
				end
			end

			sleep rand(0)
			data = @localBuffer[@rear]
			# P(empty)
			puts "Producer waiting for empty. Local buffer index = #{@rear}"
			@ts.take([:Sem, :Empty])
			puts "Producer wrote datum #{data} to buffer"
			@ts.write([:buf, data])
			@rear = (@rear +1) % @BufferSize
			# V(full)
			@ts.write([:Sem, :Full])
			puts "Producer signals for full"
		end
	end
end

prod = Producer.new(1)
prod.run
