require 'rails_helper'

RSpec.describe CountingWorker, type: :worker do

  describe '#perform' do
    let(:worker) { CountingWorker.new }
    let(:redis) { double }
    let(:counter) { double }
    let(:key) { "key" }
    let(:count) { 1 }
    let(:counters) { { key => count } }

    before(:each) do
      allow(worker).to receive(:input_redis).and_return(redis)
      allow(worker).to receive(:words_redis).and_return(redis)
      allow(redis).to receive(:get).with("bob_marley").and_return("No Woman No Cry")
      allow(redis).to receive(:incrby).with(key, count)
      allow(WordCounter).to receive(:new).and_return(counter)
      allow(counter).to receive(:count).with("No Woman No Cry")
      allow(counter).to receive(:counters).and_return(counters)
    end

    it "fetches the text" do
      worker.perform("bob_marley")

      expect(redis).to have_received(:get).with("bob_marley")
    end

    it "initializes a WordCounter and send the text for counting" do
      worker.perform("bob_marley")

      expect(counter).to have_received(:count).with("No Woman No Cry")
    end

    it "persists the counters" do
      worker.perform("bob_marley")

      expect(redis).to have_received(:incrby).with(key, count)
    end
  end
end
