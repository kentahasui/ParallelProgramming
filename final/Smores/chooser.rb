## Kenta Hasui
## CS377: Spring 2015
## Final Part 1: Smores
## chooser.rb

## This file represents the fourth child, who has a 
## stomach ache and cannot eat. The chooser runs for 50 iterations. 
## The chooser first chooses an ingredient to NOT put on the table. 
## They place the other two ingredients on the table, and signals
## the child with the required ingredient to make the SMore. 
## For example, if the chooser chose Marshmallows, then the (s)he 
## will place Graham Crackers and Chocolate onto the table (tuple space)
## and signal the child with the marshmallows that they can start
## eating. Then the chooser will wait for the child to finish 
## before choosing another ingredient. 

## Shared Variables: 3 Ingredient Semaphores, 
## 3 Ready Semaphores, and 1 Finished semaphore

require 'rinda/rinda'
URI = "druby://:4000"
DRb.start_service 
ts = Rinda::TupleSpaceProxy.new(DRbObject.new(nil, URI))

MARSH = "Marshmallows"
GRAHAM = "Graham Crackers"
CHOC = "Chocolate"

90.times do |i|
  ## Instead of choosing two ingredients that we will place on the
  ## table, we choose one that we WON'T place. This simplifies the code. 
  ## Use the built-in random function.
  random = rand(3)
  ingredient_needed = ""
  # Case 1: chose Marshmallows
  if random == 0 
    ingredient_needed = MARSH
    ts.write([:Ingredient, GRAHAM])
    ts.write([:Ingredient, CHOC])
    puts "I've placed Graham Crackers and Chocolate on the table"
  ## Case 2: chose graham crackers
  elsif random == 1
    ingredient_needed = GRAHAM
    ts.write([:Ingredient, CHOC])
    ts.write([:Ingredient, MARSH])
    puts "I've placed Chocolate and Marshmallows on the table"
  ## Case 3: chose chocolate
  elsif random == 2
    ingredient_needed = CHOC
    ts.write([:Ingredient, MARSH])
    ts.write([:Ingredient, GRAHAM])
    puts "I've placed Marshmallows and Graham Crackers on the table"
  else 
    puts "Error: unknown value for random: #{random}"
  end ## End if statements
  ## Let the child with the necessary ingredient know he can eat!
  puts "Letting the child with #{ingredient_needed} know that he can eat"
  ts.write([:Ready, ingredient_needed])
  puts "Waiting for child with #{ingredient_needed} to finish eating"
  ## Wait for child to finish eating, and print out how many smores
  ## have been made so far
  ts.take([:Finished])
  puts "The child with #{ingredient_needed} has finished eating."
  puts "We have made #{i + 1} smores so far."
end
