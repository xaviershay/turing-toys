require 'turing_toy/configuration'

module TuringToy
  # A (3, 3) machine that adds one to a number. Alphabet is 1 and 0 to
  # represent the number as binary, and a blank. Read head starts on the least
  # significant bit.
  class Rogozhin218 < Configuration
    attr_reader :config

    def self.wrap(config)
      new(config)
    end

    def initialize(config)
      @config = config
    end

    def name
      "TuringToy::Rogozhin218"
    end

    def rules
      {
        1 => {
          "1"   => ["c2", L, 1],
          "1R"  => ["1L1", R, 1],
          "1L"  => ["c2", L, 1],
          "1R1" => ["1", R, 1],
          "1L1" => ["1R1", L, 1],
          "b"   => ["bL", R, 1],
          "bR"  => ["bL1", R, 1],
          "bL"  => ["b", L, 1],
          "bR1" => ["b", R, 1],
          "bL1" => ["bR1", L, 1],
          "b2"  => ["b3", L, 2],
          "b3"  => ["bR1", L, 2],
          "c"   => ["1R", L, 2],
          "cR"  => ["cL", R, 1],
          "cL"  => ["cR1", L, 1],
          "cR1" => ["cL1", R, 2],
          #"cL1" => ["H", 0, 1],
          "c2"  => ["1L", R, 1]
        },
        2 => {
          "1"   => ["1L", R, 2],
          "1R"  => ["1L", R, 2],
          "1L"  => ["1R", L, 2],
          "1R1" => ["1L1", R, 2],
          "1L1" => ["1", L, 2],
          "b"   => ["b2", R, 1],
          "bR"  => ["bL", R, 2],
          "bL"  => ["bR", L, 2],
          # TODO: This was a bug!
          "bR1" => ["bL1", R, 2],
          # TODO: This was another bug!
          "bL1" => ["bR", L, 2],
          "b2"  => ["b", R, 1],
          "b3"  => ["bL1", R, 2],
          "c"   => ["cL", R, 2],
          "cR"  => ["cL", R, 2],
          "cL"  => ["cR", L, 2],
          "cR1" => ["c2", R, 2],
          "cL1" => ["c2", L, 1],
          "c2"  => ["c", L, 2]
        }
      }
    end

    def initial_state
      1
    end

    def initial_head_position(tape)
      super
    end

    def cycled?(state, tape, head, d = 0)
      state == 2 && tape[head] == "cL1"
    end

    def decode(tape, d = 4)
      remaining_tape = tape.drop_while {|x| x != "c" }
      reverse = tags.map {|k, v| [v[:n], k] }.to_h
      remaining_tape = remaining_tape[0..-2].drop(1)
      if remaining_tape.length > 0
        decoded = split(remaining_tape, "c").map(&:length).map {|x| reverse.fetch(x) }
      else
        decoded = %w()
      end

      if d > 0
        config.decode(decoded) # TODO: , d - 1)
      else
        decoded
      end
    end

    def split(arr, value = nil)
      arr = arr.dup
      result = []
      if block_given?
        while (idx = arr.index { |i| yield i })
          result << arr.shift(idx)
          arr.shift
        end
      else
        while (idx = arr.index(value))
          result << arr.shift(idx)
          arr.shift
        end
      end
      result << arr
    end

    def tags
      @tags ||= begin
        last = nil
        tags = config.rules.map {|(k, v)| [k, {production: v}]}.to_h
        
        tags.each.with_index do |(k, v), i|
          v[:n] = if last
                    last[:n] + last[:production].length + 1
                  else
                    1
                  end
          last = v
        end
        tags[config.halt_symbol] = {
          n: last[:n] + last[:production].length + 1
        }

        tags.each do |(k, v)|
          if v[:production]
            tokens = v[:production].map {|x| tags.fetch(x, last).fetch(:n) + 1 }
            tokens[0] -= 1
            v[:p] = %w(b b) + tokens.map {|x| %w(1) * x }.reverse.reduce {|x, y| x + %w(b) + y }
          else
            v[:p] = ["cL1"] * 2
          end
        end
        tags
      end
    end

    def encode(input)
      lhs = tags.values.sort_by {|x| x[:n] }.map {|x| x.fetch(:p) }.reverse.reduce(&:+) + %w(b b)
      initial_tape = config.encode(input)
      rhs = initial_tape.flat_map {|x| (%w(1) * tags.fetch(x).fetch(:n)) + %w(c) }

      lhs + rhs
    end

    def initial_head_position(tape)
      tape.length - tape.reverse.index("b") - 1
    end

    def blank_symbol
      "1L"
    end
  end
end
#symbols = %w(1L 1 1R 1L1 1R1 b bL bR bL1 bR1 b2 b3 c cL cR cL1 cR1 c2)
#
#tape = %w(1R 1R cL1)
#cursor = 0
#
#L = -1
#R = +1
#
#state = 1
#
#RULES = {
#  1 => {
#    "1"   => ["c2", L, 1],
#    "1R"  => ["1L1", R, 1],
#    "1L"  => ["c2", L, 1],
#    "1R1" => ["1", R, 1],
#    "1L1" => ["1R1", L, 1],
#    "b"   => ["bL", R, 1],
#    "bR"  => ["bL1", R, 1],
#    "bL"  => ["b", L, 1],
#    "bR1" => ["b", R, 1],
#    "bL1" => ["bR1", L, 1],
#    "b2"  => ["b3", L, 2],
#    "b3"  => ["bR1", L, 2],
#    "c"   => ["1R", L, 2],
#    "cR"  => ["cL", R, 1],
#    "cL"  => ["cR1", L, 1],
#    "cR1" => ["cL1", R, 2],
#    "cL1" => ["H", 0, 1],
#    "c2"  => ["1L", R, 1]
#  },
#  2 => {
#    "1"   => ["1L", R, 2],
#    "1R"  => ["1L", R, 2],
#    "1L"  => ["1R", L, 2],
#    "1R1" => ["1L1", R, 2],
#    "1L1" => ["1", L, 2],
#    "b"   => ["b2", R, 1],
#    "bR"  => ["bL", R, 2],
#    "bL"  => ["bR", L, 2],
#    # TODO: This was a bug!
#    "bR1" => ["bL1", R, 2],
#    # TODO: This was another bug!
#    "bL1" => ["bR", L, 2],
#    "b2"  => ["b", R, 1],
#    "b3"  => ["bL1", R, 2],
#    "c"   => ["cL", R, 2],
#    "cR"  => ["cL", R, 2],
#    "cL"  => ["cR", L, 2],
#    "cR1" => ["c2", R, 2],
#    "cL1" => ["c2", L, 1],
#    "c2"  => ["c", L, 2]
#  }
#}
#
#LABELS = {
#  "1" => "1 ",
#  "1R" => "1⃗ ",
#  "1L" => "1⃖ ",
#  "1R1" => "1⃗₁",
#  "1L1" => "1⃖₁",
#  "b" => "b ",
#  "bR" => "b⃗ ",
#  "bL" => "b⃖ ",
#  "bR1" => "b⃗₁",
#  "bL1" => "b⃖₁",
#  "b2" => "b₂",
#  "b3" => "b₃",
#  "c" => "c ",
#  "cR" => "c⃗ ",
#  "cL" => "c⃖ ",
#  "cR1" => "c⃗₁",
#  "cL1" => "c⃖₁",
#  "c2" => "c₂",
#
#  "H" => "!!"
#}
#
#ENCODING = LABELS.keys.zip(('a'..'z').select {|x| x != "q" }).map(&:reverse).to_h
#
#replicator = {
#  "a" => {
#    production: "aa"
#  },
#  "b" => {}
#}
#
#collatz = {
#  "a" => {production: "bc"},
#  "b" => {production: "a"},
#  "c" => {production: "aaa"},
#  "d" => {production: "d"}
#}
#
#
#demo = {
#  "a" => {production: "ccbad"},
#  "b" => {production: "cca"},
#  "c" => {production: "cc"},
#  "d" => {} # => HALT
#}
#
#tags, initial_tape = replicator, "aaa"
#tags, initial_tape = demo, "baa"
#tags, initial_tape = collatz, "aa"
#
#
#last = nil
#tags.each.with_index do |(k, v), i|
#  v[:n] = if last
#            last[:n] + last[:production].length + 1
#          else
#            1
#          end
#  last = v
#end
#
#require 'pp'
#tags.each do |(k, v)|
#  if v[:production]
#    tokens = v[:production].chars.map {|x| tags.fetch(x).fetch(:n)  + 1 }
#    tokens[0] -= 1
#    v[:p] = "ff" + tokens.map {|x| 'a' * x }.reverse.join("f")
#  else
#    v[:p] = "rr"
#  end
#end
#lhs = tags.values.sort_by {|x| x[:n] }.map {|x| x.fetch(:p) }.reverse.join + "ff"
#
#rhs = initial_tape.chars.map {|x| ("a" * tags.fetch(x).fetch(:n)) + "m" }.join
#
#tape = lhs[0..-2] + "[" + lhs[-1] + "]" + rhs
## tape = rhs + "[" + lhs[0] + "]" + lhs[1..-1]
## puts tape
## exit
## tape = "rrffafafaf[f]amamam"
## tape = "rrffafafaffaffaaaaaaafaaaaaf[f]amamam"
## tape = "rrffaffaaaf[f]aaamamam"
## tape = "rrffaaaaaffaaaf[f]aaamam"
## tape = "rrffafaf[f]amamam"
#
#extract_tags = ->{
#  x = tape[lhs.length..-1].drop_while {|x| x == "1R" }.join.split("c").map(&:length).map {|x| tags.detect {|(k, v)| v.fetch(:n) == x }[0] }
#  puts x.join
#}
#
#cursor = tape.index("[")
#tape = tape.chars.map {|x| ENCODING[x] }.compact
#i = 0
#while true
#  i += 1
##   if i > 25
##     break
##   end
#  puts "state: Q#{state}"
#  puts "tape: %s" %
#    tape.map
#      .with_index {|x, i| LABELS.fetch(x) + (i == cursor - 1 ? ">" : " ") }
#      .join("")
#  puts
#
#  element = tape[cursor]
#
#  if element == "H"
#    # Try to format tape
#    extract_tags.call
#    raise "won"
#  else
#    rule = RULES.fetch(state).fetch(element)
#    tape[cursor] = rule[0]
#    cursor += rule[1]
#    state = rule[2]
#  end
#
#  if cursor >= tape.length
#    tape.push "1L"
#  elsif cursor < 0
#    tape.unshift "1L"
#    cursor += 1
#  end
#end
#
