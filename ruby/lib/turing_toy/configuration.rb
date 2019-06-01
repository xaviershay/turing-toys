module TuringToy
  class Configuration
    def initialize(&block)
      instance_exec(&block)
    end

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

    def name
    end

    def inspect
      name ? name : super
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
