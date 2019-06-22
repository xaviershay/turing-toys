module TuringToy
  class Base
    def rules
      raise NotImplementedError
    end

    def initial_state
      raise NotImplementedError
    end

    def encode(xs)
      raise NotImplementedError
    end

    def decode(xs)
      raise NotImplementedError
    end

    def blank_symbol
      "_"
    end

    def halt_symbol
      "!"
    end

    def initial_head_position(tape)
      raise NotImplementedError
    end

    def cycled?(*)
      true
    end

    def name
    end

    def inspect
      name ? name : super
    end

    def format2(tape, head, state)
      lhs = head > 0 ? tape[0..head-1] : []
      mhs = tape[head]
      rhs = tape[head+1..-1] || []

      buffer = StringIO.new("")
      buffer.print state.to_s + ": "
      buffer.print head == 0 ? "" : " "
      buffer.print lhs.join(" ")
      buffer.print "[%s]" % mhs
      buffer.print rhs.join(" ")

      [buffer.string]
    end
  end

  class Configuration < Base
    def initialize(&block)
      instance_exec(&block)
    end


    protected

    def parse_rules(string)
      result = {}
      string.lines.map(&:strip).reject {|x| x.start_with?('#') }.each do |spec|
        name, rest = spec.split(':', 2)
        read, write, dir, next_state = rest.split(' ', 4)

        result[name] ||= {}
        raise "Already defined rule for #{spec}" if result[name][read]
        result[name][read] = [write, dir == "R" ? 1 : -1, next_state]
      end
      result
    end
  end
end
