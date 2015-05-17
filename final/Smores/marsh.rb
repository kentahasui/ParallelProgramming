## Kenta Hasui
## CS377: Spring 2015
## Final Part 1: Smores
## marsh.rb

## This file represents the child with the supply of marshmallows
## Creates a new instance of an Eater object, and passes in
## "Marshmallows" as an argument to the constructor. 

require './eater.rb'
require 'rinda/rinda'

marshmallow_child = Eater.new("Marshmallows")
marshmallow_child.eat_smore
