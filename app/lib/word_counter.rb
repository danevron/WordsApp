class WordCounter

  attr_reader :counters

  def initialize()
    @counters = Hash.new(0)
  end

  def count(text)
    text.downcase.scan(/\w+/) { |word| @counters[word] += 1 }
  end
end
