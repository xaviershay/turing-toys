require 'turing_toy/tag_configuration'

module TuringToy
  # Divides a non-negative integer by 2 (rounded down)
  DivideTwoTag = TagConfiguration.new do
    def p
      2
    end

    def rules
      {
        "a" => "b",
        "b" => "c"
      }
    end

    def encode(n)
      "aa" * n.to_i
    end

    def decode(tape)
      tape.length
    end
  end
end