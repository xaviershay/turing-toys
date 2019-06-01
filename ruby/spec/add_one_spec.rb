require 'spec_helper'
require 'rantly/rspec_extensions'
require 'rantly/shrinks'

require 'turing_toy/add_one'
require 'turing_toy/add_one_small'
require 'turing_toy/add_one_reduced'

require 'turing_toy/turing_machine'

shared_examples 'add one machine' do
  it 'adds one to positive integers' do
   property_of {
     range(0, 1000)
   }.check { |i|
     config = described_class
     machine = TuringToy::TuringMachine.new(config: config, input: i)
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

describe TuringToy::AddOneReduced do
  it_behaves_like 'add one machine'
end
