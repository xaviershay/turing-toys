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
      #{
      #  "A" => %w(B),
      #  "a" => %w(b),
      #  "B" => %w(c c c),
      #  "b" => %w(c)
      #}
    end

    def halt_symbol
      "c"
    end

    def encode(n)
      x = "aa".chars * n.to_i
      #x[0] = "a" if x.length > 0
      x
    end

    def decode(tape)
      tape.length
    end
  end
end