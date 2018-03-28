class CountingWorker
  include Sidekiq::Worker

  def perform(text_key)
    text = input_redis.get(text_key)

    if text
      counter = WordCounter.new
      counter.count(text)

      counter.counters.each do |word, count|
        words_redis.incrby(word, count)
      end
    end
  end

  private

  def input_redis
    Rails.application.config.redis
  end

  def words_redis
    Redis::Namespace.new(:wordcount, redis: Rails.application.config.redis)
  end
end
