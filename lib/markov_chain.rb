require 'pry'

class MarkovChain
  attr_reader :states, :transitions
  def initialize(states:, transitions:)
    @states = states
    @transitions = transitions
  end

  def transition_possibility(current_state, next_state)
    total_transitions = transitions[states.index(current_state)].reduce(:+)
    transitions[states.index(current_state)][states.index(next_state)].to_f / total_transitions
  end
end

class MarkovEvent
  attr_reader :chain, :state

  def initialize(chain:, state: nil)
    @chain = chain
    @state = state || chain.states[0]
  end

  def next_event
    MarkovEvent.new(chain: chain, state: next_state)
  end

  def next_state
    rand = random_number
    window = 0.0
    chain.states.each do |possible_state|
      transition_possibility = chain.transition_possibility(state, possible_state)
      window += transition_possibility
      return possible_state if rand <= window
    end
  end

  def random_number
    Random.new.rand(1.0)
  end
end

# states = ["Cheese", "Grapes", "Lettuce"]
# transitions = [
#   [0, 2, 3],
#   [0.4, 0.1, 0.5],
#   [0.6, 0.4, 0]
# ]

# chain = MarkovChain.new(states: states, transitions: transitions)

# event = MarkovEvent.new(chain: chain)

# cheese = 0
# grapes = 0
# lettuce = 0

# 100000.times do
#   next_event = event.next_event
#   if event.state == 'Grapes'
#     if next_event.state == 'Grapes'
#       grapes += 1
#     elsif next_event.state == 'Lettuce'
#       lettuce += 1
#     elsif next_event.state == 'Cheese'
#       cheese += 1
#     end
#   end

#   event = next_event
# end

# total = cheese + grapes + lettuce
# puts cheese.to_f / total
# puts grapes.to_f / total
# puts lettuce.to_f / total
