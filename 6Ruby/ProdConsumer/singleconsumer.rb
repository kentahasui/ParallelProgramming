## Kenta Hasui
## CS377: Spring 2015
## Assignment 6: Single Buffer Consumer

require 'rinda/rinda'
URI = "druby://:4000"
DRb.start_service

class Consumer
	def initialize(id)
		@ts = Rinda::TupleSpaceProxy.new(DRbObject.new(nil, URI))
		@id = id
		#Get size of local buffer from tuple space
		name, @localBufferSize = @ts.read([:Size, Numeric])
		@localBuffer = Array.new(@localBufferSize)
		# Pointer to next array index to read values into
		@pointer = 0
	end

	def run
		while true
			sleep rand(0)
			# P(Full)
			puts "Consumer waiting for Full Semaphore. Local Buffer index = #{@pointer}"
			# Fetch data from buffer, and consume it
			@ts.take([:Sem, :Full])
		  name, result = @ts.take([:buf, Numeric])
			@localBuffer[@pointer] = result
			@pointer = (@pointer + 1) % @localBufferSize
			puts "Consumer consumes datum #{result}"
			# V(Empty)
			@ts.write([:Sem, :Empty])
		end
	end
end

consumer = Consumer.new(1)
consumer.run

