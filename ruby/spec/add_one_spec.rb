require 'spec_helper'
require 'rantly/rspec_extensions'

require 'turing_toy/add_one'

describe 'Add one' do
  it 'adds one to positive integers' do
   property_of {
     range(0, 100)
   }.check { |i|
     machine = TuringToy::AddOne.create(initial: i)
     machine.run
     expect(machine.output).to eq(i+1)
   }
  end
end
