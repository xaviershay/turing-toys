require 'turing_toy/configuration'

module TuringToy
  # A (3, 3) machine that adds one to a number. Alphabet is 1 and 0 to
  # represent the number as binary, and a blank. Read head starts on the least
  # significant bit.
  AddOne = Configuration.new do
    def rules
      parse_rules <<-EOS
        Q1: 0 1 R Q3
        Q1: 1 0 L Q2
        Q2: 0 1 R Q3
        Q2: 1 0 L Q2
        Q2: _ 1 R Q3
        Q3: 0 0 R Q3
      EOS
    end

    def initial_state
      "Q1"
    end

    def initial_head_position(tape)
      tape.length - 2
    end

    def decode(tape)
      tape[1..-2].join.to_i(2)
    end

    def encode(n)
      # Include a redundant blank symbol so that the tape won't shift when
      # formatted.
      [blank_symbol] + n.to_i.to_s(2).chars + [blank_symbol]
    end
  end
end

