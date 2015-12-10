require 'pry'
require_relative './markov_chain'

class WordTrainer
  attr_reader :transitions_array

  def initialize(file_url)
    @file = File.new(file_url)
  end

  def words
    @words ||= @file.read.split(/[^a-zA-Z]/).reject { |word| word.empty? }
  end

  def uniq_words
    @uniq_words ||= words.uniq
  end

  def train
    @transitions_array = Array.new(uniq_words.count) { Array.new(uniq_words.count, 0) }
    (0..words.length-2).each do |index|
      current_word = @words[index]
      next_word = @words[index + 1]
      @transitions_array[uniq_words.index(current_word)][uniq_words.index(next_word)] += 1
    end
  end
end

trainer = WordTrainer.new('lib/training_data.txt')
trainer.train

chain = MarkovChain.new(states: trainer.uniq_words, transitions: trainer.transitions_array)

event = MarkovEvent.new(chain: chain)

10.times do
  20.times do
    print "#{event.state} "
    event = event.next_event
  end
  puts '.'
end

