require 'pry'

class MarkovChain
  attr_reader :states, :transitions
  def initialize(states:, transitions:)
    @states = states
    @transitions = transitions
  end

  def transition_possibility(current_state, next_state)
    transitions[states.index(current_state)][states.index(next_state)]
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

states = ["Cheese", "Grapes", "Lettuce"]
transitions = [
  [0, 0.5, 0.5],
  [0.4, 0.1, 0.5],
  [0.6, 0.4, 0]
]

chain = MarkovChain.new(states: states, transitions: transitions)

event = MarkovEvent.new(chain: chain)

grape = 0
lettuce = 0

100000.times do
  next_event = event.next_event
  if event.state == 'Cheese' && next_event.state == 'Grapes'
    grape += 1
  elsif event.state == 'Cheese' && next_event.state == 'Lettuce'
    lettuce += 1
  end
  event = next_event
end

puts grape
puts lettuce
