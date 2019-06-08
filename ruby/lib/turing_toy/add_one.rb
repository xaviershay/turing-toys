require 'turing_toy/configuration'

module TuringToy
  # A (3, 3) machine that adds one to a number. Alphabet is 1 and 0 to
  # represent the number as binary, and a blank. Read head starts on the least
  # significant bit.
  AddOne = Configuration.new do
    def name
      "TuringToy::AddOne"
    end

    def rules
      parse_rules <<-EOS
        Q1: 0 1 R Q2
        Q1: 1 0 L Q1
        Q1: _ 1 R Q2
        Q2: 0 0 R Q2
      EOS
    end

    def initial_state
      "Q1"
    end

    def initial_head_position(tape)
      tape.length - 2
    end

    def decode(tape)
      tape.reject {|x| [blank_symbol, halt_symbol].include?(x) }.join.to_i(2)
    end

    def encode(n)
      # Include a redundant blank symbol so that the tape won't shift when
      # formatted.
      [blank_symbol] + n.to_i.to_s(2).chars + [blank_symbol]
    end
  end
end

