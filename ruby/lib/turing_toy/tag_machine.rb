module TuringToy
  class TagMachine
    attr_reader :config, :tape

    def initialize(config:, input:)
      @config = config
      @tape = config.encode(input)
    end

    def run
      while step
      end
    end

    def step
      x = tape[0]
      rule = config.rules.fetch(x, nil)

      @tape = tape.drop(2)
      unless rule
        return false
      end

      @tape = tape + rule

      true
    end

    def output
      config.decode(tape)
    end
  end
end
