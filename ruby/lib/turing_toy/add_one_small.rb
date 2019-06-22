module TuringToy
  # A (7, 2) machine that adds one to a number. The number is encode to the
  # tape as binary, except each bit is encoded as a two-bit word, allowing for
  # a word to represent blank.
  #
  #     0 = 10
  #     1 = 11
  #     _ = 00
  #
  # The algorithm is the same as AddOne, adjusted for word size.
  AddOneSmall = Configuration.new do
    R = 1
    L = -1

    def name
      "TuringToy::AddOneSmall"
    end

    def initial_head_position(tape)
      tape.length - 1
    end

    def initial_state
      0
    end

    def blank_symbol
      "0"
    end

    def cycled?(tape, head, state)
      state == "11" && tape[head] == "0"
    end

    def rules
      {
        0 => {
          # If LSB == 1, then word is a 1. Set it 0, skip over the MSB (we can
          # assume MSB is already a 1, since 01 is not a valid), then loop.
          # word.)
          "1" => ["0", L, 2],
          "0" => ["0", L, 1]
        },
        # Check MSB when LSB was 0
        1 => {
          # Blank, we're done.
          "0" => ["1", R, 3],
          # 0. Set to 1 and we're done.
          "1" => ["1", R, 3]
        },
        # MSB when LSB was 1. Skip over to next word (carry).
        2 => {
          "1" => ["1", L, 0]
        },

        # LSB when incrementing
        3 => {
          "0" => ["1", L, 10],
        },

        # MSB returning
        10 => {
          "0" => ["0", R, 11],
          "1" => ["1", R, 12]
        },
        # LSB returning when MSB was 0.
        11 => {
          "1" => ["1", R, 10]
        },
        # LSB returning when MSB was 1. Skip.
        12 => {
          "0" => ["0", R, 10],
          "1" => ["1", R, 10]
        }
      }
    end

    def format2(tape, head, state)
      deeper = [
        if cycled?(tape, head, state)
          decode(tape) rescue nil
        end
      ].compact

      super + deeper
    end

    def decode(tape, d = 100)
      tape.take_while {|x| halt_symbol != x }.join.scan(/[01]{2}/).map do |cs|
        case cs
        when "11" then "1"
        when "10" then "0"
        when "00" then " "
        else raise "Unexpected word: #{cs}"
        end
      end.join.to_i(2)
    end

    def encode(n)
      n.to_i.to_s(2).chars.map do |c|
        case c
        when "1" then "11"
        when "0" then "10"
        else raise "Unknown char: #{c}"
        end
      end.join.chars
    end
  end
end

