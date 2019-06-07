require 'spec_helper'
require 'rantly/rspec_extensions'
require 'rantly/shrinks'

require 'turing_toy/divide_two_tag'
require 'turing_toy/tag_machine'

shared_examples 'divide two machine' do
  it 'adds one to positive integers' do
   property_of {
     range(2, 100)
   }.check { |i|
     config = described_class
     machine = TuringToy::TagMachine.new(config: config, input: i)
     machine.run
     expect(machine.output).to eq(i/2)
   }
  end
end

describe TuringToy::DivideTwoTag do
  it_behaves_like 'divide two machine'
end