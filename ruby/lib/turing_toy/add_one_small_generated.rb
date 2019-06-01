module TuringToy
  # A (m, 2) machine that adds one to a number. It is a template for what an
  # auto-generated version of an (m, 3) machine could look like.
  class AddOneSmallGenerated
    HALT = "!"
    L = -1
    R = 1

    attr_reader :tape, :head, :state, :blank

    def self.create(initial: )
      new(initial)
    end

    def initialize(initial)
      @blank = "0"
      @state = "1 LSB"
      @tape = encode(initial)
      @tape.unshift(@blank)
      @tape.unshift(@blank)
      @tape.push(@blank)
      @tape.push(@blank)
      @head = @tape.length - 3
    end

    def rules
      {
        # Read LSB, state 0
        "1 LSB" => {
          "0" => ["0", L, "1 MSB (0)"],
          "1" => ["1", L, "1 MSB (1)"]
        },
        "1 MSB (0)" => {
          "0" => [HALT], # Blank
          "1" => ["1", R, "1 1R"]
        },
        "1 1R" => {
          "0" => ["1", R, "3 from R"],
          "1" => ["1", R, "3 from R"]
        },

        "1 MSB (1)" => {
          "0" => [HALT], # Invalid
          "1" => ["1", R, "1 0L (LSB)"],
        },
        "1 0L (LSB)" => {
          "0" => ["0", L, "1 0L (MSB)"],
          "1" => ["0", L, "1 0L (MSB)"]
        },
        "1 0L (MSB)" => {
          "0" => ["1", L, "2 LSB"],
          "1" => ["1", L, "2 LSB"]
        },

        "2 from R" => {
          "0" => ["0", R, "2 LSB"],
          "1" => ["1", R, "2 LSB"]
        },
        "2 LSB" => {
          "0" => ["0", L, "2 MSB (0)"],
          "1" => ["1", L, "2 MSB (1)"]
        },
        "2 MSB (0)" => {
          "0" => ["1", R, "2 1R"], # Blank. Write a 1, Q3.
          "1" => ["1", R, "2 1R"] # 0. Write a 1, Q3.
        },
        "2 MSB (1)" => {
          "0" => [HALT], # Invalid
          "1" => ["1", R, "2 0L (LSB)"]
        },
        "2 1R" => {
          "0" => ["1", R, "3 from R"],
          "1" => ["1", R, "3 from R"]
        },
        "2 0L (LSB)" => {
          "0" => ["0", L, "2 0L (MSB)"],
          "1" => ["0", L, "2 0L (MSB)"]
        },
        "2 0L (MSB)" => {
          "0" => ["1", L, "2 LSB"],
          "1" => ["1", L, "2 LSB"]
        },


        "3 from R" => {
          "0" => ["0", R, "3 LSB"],
          "1" => ["1", R, "3 LSB"]
        },
        "3 LSB" => {
          "0" => ["0", L, "3 MSB (0)"],
          "1" => ["1", L, "3 MSB (1)"]
        },
        "3 MSB (0)" => {
          "0" => [HALT], # Blank
          "1" => ["1", R, "3 0R"] # 0, seek R
        },
        "3 MSB (1)" => {
          "0" => [HALT], # Invalid
          "1" => [HALT], # 1. Should never occur.
        },
        "3 0R" => {
          "0" => ["0", R, "3 from R"],
          "1" => ["1", R, "3 from R"]
        }
      }
    end

    def run
      while step
      end
    end

    def step
      element = tape[head]

      if element == HALT
        return false
      else
        rule = rules.fetch(state).fetch(element)
        tape[head] = rule[0]
        if rule[1]
          @head += rule[1]
          @state = rule[2]
        end
      end

      if head >= tape.length
        tape.push blank
      elsif head < 0
        tape.unshift blank
        @head += 1
      end

      true
    end

    def output
      tape[0..-3].join.scan(/[01]{2}/)
      tape[0..-3].join.scan(/[01]{2}/).map do |cs|
        case cs
        when "11" then "1"
        when "10" then "0"
        when "00" then " "
        else raise "Unexpected word: #{cs}"
        end
      end.join.to_i(2)
    end

    def formatted_tape
      lhs = head > 0 ? tape[0..head-1] : []
      mhs = tape[head]
      rhs = tape[head+1..-1]

      max_rule_len = rules.keys.map(&:length).max
      buffer = StringIO.new("")
      buffer.print "%#{max_rule_len}s: " % state
      buffer.print head == 0 ? "" : " "
      buffer.print lhs.join(" ")
      buffer.print "[%s]" % mhs
      buffer.print rhs.join(" ")
      buffer.string
    end

    private

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

