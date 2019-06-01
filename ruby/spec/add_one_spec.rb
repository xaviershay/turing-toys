require 'spec_helper'
require 'rantly/rspec_extensions'

require 'turing_toy/add_one'
require 'turing_toy/add_one_small'
require 'turing_toy/add_one_small_generated'
require 'turing_toy/three_two_reducer'


shared_examples 'add one machine' do
  it 'adds one to positive integers' do
   property_of {
     range(0, 100)
   }.check { |i|
     machine = described_class.create(initial: i)
     machine.run
     expect(machine.output).to eq(i+1)
   }
  end
end

describe TuringToy::AddOne do
  it_behaves_like 'add one machine'
end

describe TuringToy::AddOneSmall do
  it_behaves_like 'add one machine'
end

describe TuringToy::AddOneSmallGenerated do
  it_behaves_like 'add one machine'
end

describe TuringToy::ThreeTwoReducer.wrap(TuringToy::AddOne) do
  it_behaves_like 'add one machine'
end
