$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'turing_toy'
require 'turing_toy/turing_machine'
require 'turing_toy/tag_machine'
require 'turing_toy/turing_tag'

# require 'benchmark'
require 'benchmark/plot'

cases = [
  ["(2, 3)", TuringToy::AddOne, TuringToy::TuringMachine],
  ["(7, 2)", TuringToy::AddOneSmall, TuringToy::TuringMachine],
  ["(m, 2)", TuringToy::AddOneReduced, TuringToy::TuringMachine],
  ["(7, 2) tag", TuringToy::TuringTag.wrap(TuringToy::AddOneSmall), TuringToy::TagMachine]
  #["(m, 2) tag", TuringToy::TuringTag.wrap(TuringToy::ThreeTwoReducer.wrap(TuringToy::AddOne)), TuringToy::TagMachine],
]

Benchmark.plot((0..5)) do |x|
  cases.each do |c|
    x.report("#{c[0]}") {|i|
      instance = c[2].new(config: c[1], input: 2**i)
      instance.run
    }
  end
end