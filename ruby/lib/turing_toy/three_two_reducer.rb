module TuringToy
  # A meta-configuration that translates a (m, 3) machine into a (m, 2) one.
  # Quite inefficient compared to a hand tuned one (see AddOneSmall), but gets
  # the job done.
  #
  # Basic method is to split each symbol into a 2-bit word. Each rule is then
  # split into a read phase that looks at both bits, then a write phase that
  # moves back to the LSB then traverses either L or R 2 bits to the next word.
  class ThreeTwoReducer < Configuration
    L = -1
    R = 1

    attr_reader :config

    def self.wrap(config)
      new(config)
    end

    def name
      "#{self.class.name}<#{config.name}>"
    end

    def initial_state
      name_for(config.initial_state, "Read LSB")
    end

    def initial_head_position(tape)
      tape.length - 1
    end

    def rules
      @rules ||= generate_rules
    end

    def blank_symbol
      "0"
    end

    def decode(tape)
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

    protected

    def base_rules
      config.rules
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

    def initialize(config)
      @config = config
    end

    def generate_rules
      alphabet = base_rules.values.flat_map(&:keys).uniq.reject {|x| config.blank_symbol == x}.sort
      unless alphabet == %w(0 1)
        raise NotImplementedError, "Currently 0 and 1 are hard coded."
      end

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

        rule = state.fetch("0", nil)
        if rule
          dir = dir_label(rule[1])
          new_rules[name_for(q, "Read MSB (0)")] = {}
          new_rules[name_for(q, "Read MSB (0)")]["1"] = [
            expand(rule[0])[0],
            R,
            name_for(q, "LSB = #{rule[0]} #{dir} #{rule[2]}")
          ]
        end

        rule = state.fetch("_", nil)
        if rule
          new_rules[name_for(q, "Read MSB (0)")]["0"] = [
            expand(rule[0])[0],
            R,
            name_for(q, "LSB = #{rule[0]} #{dir} #{rule[2]}")
          ]
        end

        rule = state.fetch("1", nil)
        if rule
          dir = dir_label(rule[1])
          new_rules[name_for(q, "Read MSB (1)")] = {}
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
end
