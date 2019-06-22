require 'turing_toy/configuration'
require 'turing_toy/add_one_small'

module TuringToy
  # Converts an (m, 2) Turing machine into a P-2 tag system, as described in
  # "Universality of TAG Systems with P-2" (Cocke & Minsky, 1964).
  #
  # https://cs.famaf.unc.edu.ar/~hoffmann/cc18/p15-cocke.pdf
  #
  # Rather than use the "x" symbol for unused, we instead here repeat the
  # primary symbol in the word. This makes encoding this system into other
  # systems easier down the line.
  #
  # The t0 rule doesn't match the paper, which was needed to get this to
  # actually work - as far as I can tell this is a mistake in the paper.
  class TuringTag < Configuration
    def self.wrap(config)
      new(config)
    end

    attr_reader :config

    L = -1
    R = 1

    def wrapped
      config
    end

    def initialize(config)
      @config = config
    end

    def name
      "#{self.class.name}<#{config.name}>"
    end

    def rules

      if wrapped.blank_symbol != "0"
        raise NotImplementedError
      end

      template = wrapped.rules
      #template = {
        #"Q1" => {
          #"0" => ["0", L, "Q2"],
          #"1" => ["1", R, "Q2"]
        #},
        #"Q2" => {
          #"0" => ["0", L, "Q1"],
          #"1" => ["1", R, "Q1"]
        #}
      #}
      template.flat_map do |state_name, state_rules|
        [0, 1].map do |i|
          rule = state_rules.fetch(alphabet.fetch(i), nil) # TODO: Handle no rule
          if rule
            rules_for_state2(state_name, i, reverse_alphabet.fetch(rule[0]), rule[1], rule[2])
          else
            # No rules for this case, will result in halt
            {}
          end
        end
      end.reduce(&:merge)
    end

    def alphabet
      {
        0 => "0",
        1 => "1"
      }
    end

    def reverse_alphabet
      alphabet.invert
    end

    def encode(x)
      tape = wrapped.encode(x)
      head_position = wrapped.initial_head_position(tape)

      lhs = tape[0..head_position-1].map {|x| reverse_alphabet.fetch(x) }.join
      rhs = tape[head_position+1..-1].map {|x| reverse_alphabet.fetch(x) }.join
      head = reverse_alphabet.fetch(tape[head_position])

      # TODO: Set real numbers
      m = lhs.to_i(2)
      n = rhs.reverse.to_i(2)

      l = -> xs {
        suffix = "/#{initial_state}/#{head}"
        if xs.is_a?(Array)
          xs.map {|x| x + suffix }
        else
          xs + suffix
        end
      }

      l[%w(A A) + (%w(a a) * m) + %w(B B) + (%w(b b) * n)]
    end

    # TODO: Delegate to wrapped config
    def initial_state
      wrapped.initial_state
    end

    def cycled?(tape, d = 0)
      fixed_tape = tape

#       if %w(a B).include?(tape[0][0]) && !rules[tape[0]]
#         fixed_tape = %w(A A) + tape
#       end

      return fixed_tape[0][0] == "A"
    end

    def format2(tape)
      max_length = tape.map {|x| x.length }.max
      n = 0

      formatted = ("  " * n) + if max_length > 1
        tape.join(' ')
      else
        tape.join
      end

      deeper = if cycled?(tape)
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

        state = tape[0].split("/")[1]
        head = reverse_alphabet.fetch(tape[0].split("/")[2])
        tape = ""
        tape << m.to_s(2) if m > 0
        tape << head.to_s
        tape << n.to_s(2).reverse if n > 0

        tape = tape.chars.map {|x|
          alphabet.fetch(x.to_i)
        }

        wrapped.format2(tape, m > 0 ? m.to_s(2).chars.length : 0, state)
      else
        []
      end

      [formatted] + deeper
    end

    def rules_for_state2(state_name, branch, s, direction, next_state_name)
      n = -> xs {
        suffix = "/#{state_name}/#{branch}"
        if xs.is_a?(Array)
          xs.map {|x| x + suffix }
        else
          xs + suffix
        end
      }

      n0 = -> xs {
        suffix = "/#{next_state_name}/0"
        if xs.is_a?(Array)
          xs.map {|x| x + suffix }
        else
          xs + suffix
        end
      }

      n1 = -> xs {
        suffix = "/#{next_state_name}/1"
        if xs.is_a?(Array)
          xs.map {|x| x + suffix }
        else
          xs + suffix
        end
      }

      if direction > 0 # R
        {
          n["A"] => s == 0 ? n[%w(C C)] : n[%w(C C c c)],
          n["a"] => n[%w(c c c c)],
          n["B"] => n[%w(S)],
          n["b"] => n[%w(s)],
          n["C"] => n[%w(D1 D0)],
          n["c"] => n[%w(d1 d0)],
          n["S"] => n[%w(T1 T0)],
          n["s"] => n[%w(t1 t0)],
          n["D1"] => n1[%w(A A)],
          n["d1"] => n1[%w(a a)],
          n["T1"] => n1[%w(B B)],
          n["t1"] => n1[%w(b b)],

          n["D0"] => n0[%w(A A A)],
          n["d0"] => n0[%w(a a)], 
          n["T0"] => n0[%w(B B)],
          n["t0"] => n0[%w(b b)]
        }
      else
        {
          n["A"] => n[%w(C)],
          n["a"] => n[%w(c)],
          n["B"] => s == 0 ? n[%w(S S)] : n[%w(S S s s)],
          n["b"] => n[%w(s s s s)],
          n["C"] => n[%w(D1 D0)],
          n["c"] => n[%w(d1 d0)],
          n["S"] => n[%w(T1 T0)],
          n["s"] => n[%w(t1 t0)],
          n["D1"] => n1[%w(A A)],
          n["d1"] => n1[%w(a a)],
          n["T1"] => n1[%w(B B)],
          n["t1"] => n1[%w(b b)],

          n["D0"] => n0[%w(A A A)],
          n["d0"] => n0[%w(a a)],
          n["T0"] => n0[%w(B B)],
          n["t0"] => n0[%w(b b)]
        }
      end
    end

    # These rules (0/1, R, same state)
    def __rules_for_state(name, state_rules)
      # TODO
      # Means we are writing a 0
      s = 1

      n = -> xs {
        if xs.is_a?(Array)
          xs.map {|x| x + name }
        else
          xs + name
        end
      }

      {
        n["A"] => s == 0 ? n[%w(C C)] : n[%w(C C c c)],
        n["a"] => n[%w(c c c c)],
        n["B"] => n[%w(S)],
        n["b"] => n[%w(s)],
        n["C"] => n[%w(D1 D0)],
        n["c"] => n[%w(d1 d0)],
        n["S"] => n[%w(T1 T0)],
        n["s"] => n[%w(t1 t0)],
        n["D1"] => n[%w(A A)], # TODO: State change to Q10
        n["d1"] => n[%w(a a)], # TODO: State change to Q10
        n["T1"] => n[%w(B B)], # TODO: State change to Q10
        n["t1"] => n[%w(b b)], # TODO: State change to Q10

        n["D0"] => n[%w(A A A)], # TODO: State change to Q11
        n["d0"] => n[%w(a a)], # TODO: State change to Q11
        n["T0"] => n[%w(B B)], # TODO: State change to Q11
        n["t0"] => n[%w(b)] # TODO: State change to Q11
      }
    end

    # These rules (0/1, L, same state)
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
        n["A"] => n[%w(C)],
        n["a"] => n[%w(c)],
        n["B"] => s == 0 ? n[%w(S S)] : n[%w(S S s s)],
        n["b"] => n[%w(s s s s)],
        n["C"] => n[%w(D1 D0)],
        n["c"] => n[%w(d1 d0)],
        n["S"] => n[%w(T1 T0)],
        n["s"] => n[%w(t1 t0)],
        n["D1"] => n[%w(A A)], # TODO: State change to Q10
        n["d1"] => n[%w(a a)], # TODO: State change to Q10
        n["T1"] => n[%w(B B)], # TODO: State change to Q10
        n["t1"] => n[%w(b b)], # TODO: State change to Q10

        n["D0"] => n[%w(A A A)], # TODO: State change to Q11
        n["d0"] => n[%w(a a)], # TODO: State change to Q11  TODO maybe drop x here?
        n["T0"] => n[%w(B B)], # TODO: State change to Q11
        n["t0"] => n[%w(b b)] # TODO: State change to Q11
      }
    end
  end
end
