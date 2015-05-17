## Kenta Hasui
## CS377: Spring 2015
## Final Part 1: Smores
## graham.rb

## This file represents the child with the supply of Graham Crackers
## Creates a new instance of an Eater object, and passes in
## "Graham Crackers" as an argument to the constructor. 

require './eater.rb'
require 'rinda/rinda'

marshmallow_child = Eater.new("Graham Crackers")
marshmallow_child.eat_smore
