module TuringToy
  # A (3, 3) machine that adds one to a number. Alphabet is 1 and 0 to
  # represent the number as binary, and a blank. Read head starts on the least
  # significant bit.
  class AddOne
    HALT = "!"
    L = -1
    R = 1

    attr_reader :tape, :head, :state, :blank

    def self.create(initial: )
      new(initial)
    end

    def initialize(initial)
      @blank = " "
      @state = 1
      @tape = encode(initial)
      @tape.unshift(@blank)
      @head = @tape.length - 1
    end

    def rules
      {
        1 => {
          "0" => ["1", R, 3],
          "1" => ["0", L, 2],
          " " => [HALT],
        },

        2 => {
          "0" => ["1", R, 3],
          "1" => ["0", L, 2],
          " " => ["1", R, 3],
        },

        3 => {
          "0" => ["0", R, 3],
          "1" => [HALT], # Should never occur
          " " => [HALT],
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
      tape[0..-2].join.to_i(2)
    end

    def formatted_tape
      lhs = head > 0 ? tape[0..head-1] : []
      mhs = tape[head]
      rhs = tape[head+1..-1]

      buffer = StringIO.new("")
      buffer.print state.to_s + ": "
      buffer.print head == 0 ? "" : " "
      buffer.print lhs.join(" ")
      buffer.print "[%s]" % mhs
      buffer.print rhs.join(" ")
      buffer.string
    end

    private

    def encode(n)
      n.to_i.to_s(2).chars
    end
  end
end

