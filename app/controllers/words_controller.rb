class WordsController < ApplicationController
  def index
    param! :word, String, required: true, format: /^[\w|-]*$/

    render json: {}, status: 200
  end

  def count
    param! :text, String, required: true
  end

  rescue_from 'RailsParam::Param::InvalidParameterError' do |error|
    render json: { validation_error: error }, status: 422
  end
end
