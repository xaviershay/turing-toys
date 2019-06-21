require 'turing_toy/add_one_small'
require 'turing_toy/turing_tag'
require 'turing_toy/rogozhin218'

module TuringToy
  AddOneRogozhin218 = Rogozhin218.wrap(TuringTag.wrap(AddOneSmall))
end
