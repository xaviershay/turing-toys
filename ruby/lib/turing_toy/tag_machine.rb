module TuringToy
  class TagMachine
    attr_reader :config, :tape, :last_output

    def initialize(config:, input:)
      @config = config
      @tape = config.encode(input)
      @last_output = [0, nil]
    end

    def run
      while step
      end
    end

    def step
      x = tape[0]
      rule = config.rules.fetch(x, nil)

      @tape = tape.drop(2)

      f = config.format2(@tape)
      if f.length >= last_output[0]
        @last_output = [f.length, f[-1]]
      end

      unless rule
        return false
      end

      @tape = tape + rule

      true
    end

    def output
      @last_output[1]
    end
  end
end
