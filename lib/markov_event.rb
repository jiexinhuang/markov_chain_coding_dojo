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
