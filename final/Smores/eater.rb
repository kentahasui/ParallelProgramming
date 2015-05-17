## Kenta Hasui
## CS377: Spring 2015
## Final Part 1: Smores
## eater.rb

## I have created a class to represent any of the three children 
## that will eat the smores. All three mainly do the same things, 
## so I created a single class to maximize code re-use. 

# Boilerplate: initialize stuff
require 'rinda/rinda'
URI = "druby://:4000"
DRb.start_service 

## constant declarations
MARSH = "Marshmallows"
GRAHAM = "Graham Crackers"
CHOC = "Chocolate"

## Class to represent the three children who eat smores while their 
## poor friend watches
class Eater
  # Constructor. Creates a pointer to the tuple space. Takes the string
  # "Marshmallows", "Graham Crackers", or "Chocolate" as an argument
  def initialize(ingredient)
    @my_ingredient = ingredient
    @ts = Rinda::TupleSpaceProxy.new(DRbObject.new(nil, URI))
    @smores_count = 0
  end

  # Main method of execution for this class. Represents a child waiting
  # for ingredients to be placed onto the table, making a smore, and 
  # eating it. 
  def eat_smore
    # Loop forever
    while true 
      puts "Child with #{@my_ingredient}: waiting for the other ingredients"
      # Waits (blocks) until ingredients are on the table and the chooser
      # child (fourth child) gives the signal that it's okay to start eating
      @ts.take([:Ready, @my_ingredient])
      # Take two ingredients from the table. Since the only two
      # :Ingredient tuples in the tuple space are the two needed for this
      # child, we don't need to explicitly write out the ingredient names.
      # There are always at most two :Ingredient tuples in the tuple space. 
      tag, ing1 = @ts.take([:Ingredient, String])
      tag, ing2 = @ts.take([:Ingredient, String])
      puts "Child with #{@my_ingredient}: takes #{ing1} and #{ing2}"
      puts "Making a smore, and eating it"
      @smores_count = @smores_count + 1
      puts "Smore count: #{@smores_count}"
      # Lets the fourth child know that they can choose again
      @ts.write([:Finished])
      puts "Child with #{@my_ingredent}: letting the fourth child know I've finished eating"
    end
  end
end
