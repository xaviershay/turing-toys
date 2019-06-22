require 'turing_toy/tag_configuration'

module TuringToy
  # Divides an integer >= 2 by 2 (rounded down)
  DivideTwoTag = TagConfiguration.new do
    def p
      2
    end

    def rules
      #{
      #  "a" => %w(b),
      #  "b" => %w(c)
      #}
      {
        "A" => %w(B),
        "a" => %w(b),
        "B" => %w(c c c),
        "b" => %w(c)
      }
    end

    def halt_symbol
      "c"
    end

    def encode(n)
      x = "aa".chars * n.to_i
      x[0] = "A" if x.length > 0
      x
    end

    def cycled?(tape)
      tape[0] == halt_symbol
    end

    def format2(tape)
      max_length = tape.map {|x| x.length }.max || 0
      n = 0

      formatted = ("  " * n) + if max_length > 1
        tape.join(' ')
      else
        tape.join
      end

      deeper = if cycled?(tape)
        [tape.length]
      else
        []
      end

      [formatted] + deeper
    end
  end
end
