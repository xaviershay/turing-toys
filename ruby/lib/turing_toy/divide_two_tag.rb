require 'turing_toy/tag_configuration'

module TuringToy
  # Divides an integer >= 2 by 2 (rounded down)
  DivideTwoTag = TagConfiguration.new do
    def p
      2
    end

    def rules
      {
        "a" => %w(b),
        "b" => %w(c)
      }
    end

    def encode(n)
      "aa".chars * n.to_i
    end

    def decode(tape)
      tape.length
    end
  end
end