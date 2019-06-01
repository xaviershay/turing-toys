module TuringToy
  class ThreeTwoReducer
    HALT = "!"
    L = -1
    R = 1

    attr_reader :tape, :head, :state, :blank

    def self.wrap(machine)
      Class.new(ThreeTwoReducer) do
        def self.create(initial:)
          new(initial)
        end

        define_method(:base_rules) do
          machine.rules
        end
      end
    end

    def initialize(initial)
      @blank = "0"
      @state = "Q1 Read LSB"
      @tape = encode(initial)
      @tape.unshift(@blank)
      @tape.unshift(@blank)
      @tape.push(@blank)
      @tape.push(@blank)
      @head = @tape.length - 3
    end

    def expand(x)
      case x
      when "0" then "10"
      when "1" then "11"
      when " " then "00"
      end
    end

    def dir_label(x)
      if x == -1
        "L"
      else
        "R"
      end
    end

    def name_for(q, label)
      "#{q} #{label}"
    end

    def rules
      @rules ||= begin
        new_rules = {}
        base_rules.each do |(q, state)|
          new_rules[name_for(q, "Read LSB")] = {
            "0" => ["0", L, name_for(q, "Read MSB (0)")],
            "1" => ["1", L, name_for(q, "Read MSB (1)")]
          }
          new_rules[name_for(q, "from R")] = {
            "0" => ["0", R, name_for(q, "Read LSB")],
            "1" => ["1", R, name_for(q, "Read LSB")]
          }

          rule = state.fetch("0")
          dir = dir_label(rule[1])
          new_rules[name_for(q, "Read MSB (0)")] = {}
          new_rules[name_for(q, "Read MSB (0)")]["1"] = [
            expand(rule[0])[0],
            R,
            name_for(q, "LSB = #{rule[0]} #{dir} #{rule[2]}")
          ]

          rule = state.fetch(" ")
          if rule.length == 1
            # HALT
            new_rules[name_for(q, "Read MSB (0)")]["0"] = rule
          else
            new_rules[name_for(q, "Read MSB (0)")]["0"] = [
              expand(rule[0])[0],
              R,
              name_for(q, "LSB = #{rule[0]} #{dir} #{rule[2]}")
            ]
          end

          rule = state.fetch("1")
          dir = dir_label(rule[1])
          new_rules[name_for(q, "Read MSB (1)")] = {}
          if rule.length == 1
            # HALT
            new_rules[name_for(q, "Read MSB (1)")]["1"] = rule
          else
            new_rules[name_for(q, "Read MSB (1)")]["1"] = [
              expand(rule[0])[0],
              R,
              name_for(q, "LSB = #{rule[0]} #{dir} #{rule[2]}")
            ]
          end

          other_qs = base_rules.keys
          other_qs.each do |other_q|
            new_rules[name_for(q, "LSB = 0 R #{other_q}")] = {
              "0" => ["0", R, name_for(other_q, "from R")],
              "1" => ["0", R, name_for(other_q, "from R")]
            }

            new_rules[name_for(q, "LSB = 1 R #{other_q}")] = {
              "0" => ["1", R, name_for(other_q, "from R")],
              "1" => ["1", R, name_for(other_q, "from R")]
            }

            new_rules[name_for(q, "LSB = 0 L #{other_q}")] = {
              "0" => ["0", L, name_for(q, "MSB = 0 L #{other_q}")],
              "1" => ["0", L, name_for(q, "MSB = 0 L #{other_q}")]
            }

            new_rules[name_for(q, "MSB = 0 L #{other_q}")] = {
              "0" => ["1", L, name_for(other_q, "Read LSB")],
              "1" => ["1", L, name_for(other_q, "Read LSB")]
            }

            new_rules[name_for(q, "LSB = 1 L #{other_q}")] = {
              "0" => ["1", L, name_for(q, "MSB = 1 L #{other_q}")],
              "1" => ["1", L, name_for(q, "MSB = 1 L #{other_q}")]
            }

            new_rules[name_for(q, "MSB = 1 L #{other_q}")] = {
              "0" => ["1", L, name_for(other_q, "Read LSB")],
              "1" => ["1", L, name_for(other_q, "Read LSB")]
            }
          end
        end
        new_rules
      end
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
