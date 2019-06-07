require 'turing_toy/configuration'

module TuringToy
  # Converts an (m, 2) Turing machine into a P-2 tag system, as described in
  # "Universality of TAG Systems with P-2" (Cooke & Minsky, 1963).
  #
  # https://dspace.mit.edu/handle/1721.1/6107
  TuringTag = Configuration.new do
    def rules_for_state(name, state_rules)
    end
  end
end