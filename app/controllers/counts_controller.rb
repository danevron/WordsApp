class CountsController < ApplicationController
  def show
    param! :word, String, required: true, format: /^[\w|-]*$/

    word_count = words_redis.get(word.downcase)
    render json: word_count || 0, status: 200
  end

  def create
    param! :text, String, required: true

    uuid = SecureRandom.uuid
    text_redis.set(uuid, text)
    CountingWorker.perform_async(uuid)

    head :ok
  end

  rescue_from 'RailsParam::Param::InvalidParameterError' do |error|
    render json: { validation_error: error }, status: 422
  end

  private

  def word
    params[:word]
  end

  def text
    params[:text]
  end

  def text_redis
    Rails.application.config.redis
  end

  def words_redis
    Redis::Namespace.new(:wordcount, redis: Rails.application.config.redis)
  end
end
