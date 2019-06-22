require 'spec_helper'

require 'turing_toy'
require 'turing_toy/divide_two_tag'
require 'turing_toy/divide_two_rogozhin218'
require 'turing_toy/tag_machine'
require 'turing_toy/turing_machine'

shared_examples 'divide two machine' do
  (2..5).each do |n|
    it "divides #{n} by 2" do
      config = described_class
      instance = machine.new(config: config, input: n)
      instance.run
      expect(instance.output).to eq(n/2)
    end
  end
end

describe TuringToy::DivideTwoTag do
  let(:machine) { TuringToy::TagMachine }

  it_behaves_like 'divide two machine'
end

describe TuringToy::DivideTwoRogozhin218 do
  let(:machine) { TuringToy::TuringMachine }

  it_behaves_like 'divide two machine'
end
