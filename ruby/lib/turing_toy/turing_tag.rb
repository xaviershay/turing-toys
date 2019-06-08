require 'turing_toy/configuration'

module TuringToy
  # Converts an (m, 2) Turing machine into a P-2 tag system, as described in
  # "Universality of TAG Systems with P-2" (Cooke & Minsky, 1963).
  #
  # https://dspace.mit.edu/handle/1721.1/6107
  TuringTag = Configuration.new do
    def rules
      rules_for_state("0", {})
    end

    def encode(_)
      name = "0"
      l = -> xs {
        if xs.is_a?(Array)
          xs.map {|x| x + name }
        else
          xs + name
        end
      }
      m = 2
      n = 1

      l[%w(A x) + (%w(a x) * m) + %w(B x) + (%w(b x) * n)]
    end

    def decode(tape)
      return if tape[0] != "A0"

      m = 0
      n = 0
      tape.each_slice(2) do |x|
        case x[0][0]
        when "a"
          m += 1
        when "b"
          n += 1
        end
      end

      [m, n].inspect
    end

    def rules_for_state(name, state_rules)
      # TODO
      # Means we are writing a 0
      s = 0

      n = -> xs {
        if xs.is_a?(Array)
          xs.map {|x| x + name }
        else
          xs + name
        end
      }

      {
        n["A"] => n[%w(C x)],
        n["a"] => n[%w(c x)],
        n["B"] => n[%w(S)],
        n["b"] => n[%w(s)],
        n["C"] => n[%w(D1 D0)],
        n["c"] => n[%w(d1 d0)],
        n["S"] => n[%w(T1 T0)],
        n["s"] => n[%w(t1 t0)],
        n["D1"] => n[%w(A x)], # TODO: State change to Q10
        n["d1"] => n[%w(a x)], # TODO: State change to Q10
        n["T1"] => n[%w(B x)], # TODO: State change to Q10
        n["t1"] => n[%w(b x)], # TODO: State change to Q10

        n["D0"] => n[%w(x A x)], # TODO: State change to Q11
        n["d0"] => n[%w(a x)], # TODO: State change to Q11
        n["T0"] => n[%w(B x)], # TODO: State change to Q11
        n["t0"] => n[%w(b)] # TODO: State change to Q11
      }
    end
  end
end