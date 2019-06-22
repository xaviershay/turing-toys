require 'spec_helper'

require 'turing_toy/add_one'
require 'turing_toy/add_one_small'
require 'turing_toy/add_one_reduced'
require 'turing_toy/add_one_tagged'

require 'turing_toy/turing_machine'
require 'turing_toy/tag_machine'

shared_examples 'add one machine' do
  (0..5).each do |i|
    it "adds one to #{i}" do
      config = described_class
      instance = machine.new(config: config, input: i)
      instance.run
      expect(instance.output).to eq(i+1)
    end
  end
end

describe TuringToy::AddOne do
  let(:machine) { TuringToy::TuringMachine }

  it_behaves_like 'add one machine'
end

describe TuringToy::AddOneSmall do
  let(:machine) { TuringToy::TuringMachine }

  it_behaves_like 'add one machine'
end

describe TuringToy::AddOneReduced do
  let(:machine) { TuringToy::TuringMachine }

  it_behaves_like 'add one machine'
end

describe TuringToy::AddOneTagged do
  let(:machine) { TuringToy::TagMachine }

  it_behaves_like 'add one machine'
end
