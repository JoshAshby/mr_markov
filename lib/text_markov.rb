class TextMarkov
  attr_accessor :context

  def initialize context: 2
    @states  = {}
    @context = context
  end

  def train text
    text.split(/[\.!\?]/).each do |sentence|
      sentence += '.'
      arr = sentence.split
      arr.unshift(*[].fill(nil, 0, @context)) # Handle building the beginning state
      sequences = arr[0..-(@context+1)].zip(*@context.times.map{ |i| arr[i+1..-1] })

      sequences.inject(@states) do |memo, sequence|
        key = sequence[0..@context-1]

        # We have to do this, rather than make @states a Hash.new{ Array.new }
        # because ruby doesn't want to marshal a Hash with a new proc :/
        memo[key] ||= []
        memo[key] << sequence[@context]

        memo
      end
    end

    nil
  end

  def generate_sentence
    res = [].fill(nil, 0, @context)

    loop do
      choices = @states[res.last(@context)]
      break if choices.nil? || choices.empty?

      res << choices.sample
    end

    res[@context..-1].join ' '
  end

  def generate_sentences n
    n.times.map{ generate_sentence }.join ' '
  end
end
