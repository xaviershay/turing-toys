require 'turing_toy/tag_configuration'

module TuringToy
  # Infinitely generates
  Replicator = TagConfiguration.new do
    def p
      2
    end

    def rules
      {
        "a" => %w(a a)
      }
    end

    def halt_symbol
      "b"
    end

    def encode(n)
      %w(a a)
    end

    def format2(tape)
      max_length = tape.map {|x| x.length }.max || 0
      n = 0

      formatted = ("  " * n) + if max_length > 1
        tape.join(' ')
      else
        tape.join
      end

      [formatted]
    end
  end
end
