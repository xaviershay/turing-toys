$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'turing_toy'
require 'turing_toy/turing_machine'
require 'turing_toy/tag_machine'
require 'turing_toy/turing_tag'

require 'benchmark'

cases = [
  [TuringToy::AddOne, TuringToy::TuringMachine],
  [TuringToy::AddOneSmall, TuringToy::TuringMachine],
  [TuringToy::AddOneReduced, TuringToy::TuringMachine],
  [TuringToy::TuringTag.wrap(TuringToy::AddOneSmall), TuringToy::TagMachine],
  [TuringToy::TuringTag.wrap(TuringToy::ThreeTwoReducer.wrap(TuringToy::AddOne)), TuringToy::TagMachine],
]

Benchmark.bm do |x|
  cases.each do |c|
    (0..6).each do |i|
      x.report("#{c[0].name} #{i}+1") {
        instance = c[1].new(config: c[0], input: i)
        instance.run
      }
    end
  end
end