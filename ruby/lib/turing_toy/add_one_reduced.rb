require 'turing_toy/add_one'
require 'turing_toy/three_two_reducer'

module TuringToy
  AddOneReduced = ThreeTwoReducer.wrap(AddOne)
end
