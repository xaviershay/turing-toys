require 'turing_toy/add_one'
require 'turing_toy/turing_tag'
require 'turing_toy/three_two_reducer'

module TuringToy
  AddOneTagged = TuringTag.wrap(ThreeTwoReducer.wrap(AddOne))
end
