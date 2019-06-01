module TuringToy
  class TuringMachine
    attr_reader :config, :tape, :head, :state

    def initialize(config:, input:)
      @config = config
      @tape = config.encode(input)
      @head = config.initial_head_position(tape)
      @state = config.initial_state
    end

    def run
      while step
      end
    end

    def step
      element = tape[head]

      if element == config.halt_symbol
        return false
      else
        rule = config.rules.fetch(state).fetch(element, [config.halt_symbol])
        tape[head] = rule[0]
        if rule[1]
          @head += rule[1]
          @state = rule[2]
        end
      end

      if head >= tape.length
        tape.push config.blank_symbol
      elsif head < 0
        tape.unshift config.blank_symbol
        @head += 1
      end

      true
    end

    def output
      config.decode(tape)
    end
  end
end
