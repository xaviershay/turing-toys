module TuringToy
  class TagConfiguration
    def initialize(&block)
      instance_exec(&block)
    end

    def encode(input)
      raise NotImplementedError
    end

    def decode(input)
      raise NotImplementedError
    end

    def rules
      raise NotImplementedError
    end

    def p
      raise NotImplementedError
    end
  end
end