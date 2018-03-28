require 'rails_helper'

RSpec.describe WordCounter do

  describe "#count" do
    it "continuously counts word occurrences" do
      counter = WordCounter.new
      3.times { counter.count("sometext") }

      expect(counter.counters["sometext"]).to eq(3)
    end

    it "splits sentences into words without counting punctuation marks" do
      counter = WordCounter.new
      counter.count("Hi! Am I a sentence?")

      expect(counter.counters["hi"]).to eq(1)
      expect(counter.counters["sentence"]).to eq(1)
    end

    it "counts downcased words" do
      counter = WordCounter.new
      counter.count("DaNi")

      expect(counter.counters["DaNi"]).to eq(0)
      expect(counter.counters["dani"]).to eq(1)
    end
  end
end
