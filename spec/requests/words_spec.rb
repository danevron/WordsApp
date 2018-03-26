require 'rails_helper'

RSpec.describe 'Words API', type: :request do

  describe "POST words/count" do

    context "when posted data is valid" do
      let(:valid_data) { { text: "sometext" } }
      before { post '/words/count', params: valid_data }

      it "returns status code 204" do
        expect(response.status).to eq(204)
      end
    end

    context "when posted data is not valid" do
      before { post '/words/count', params: { not: "valid" } }

      it "returns status code 422" do
        expect(response.status).to eq(422)
      end

      it "returns an error" do
        expect(json).to eq({ "validation_error" => "Parameter text is required" })
      end
    end

    context "when no data is posted" do
      before { post '/words/count' }

      it "returns status code 422" do
        expect(response.status).to eq(422)
      end

      it "returns an error" do
        expect(json).to eq({ "validation_error" => "Parameter text is required" })
      end
    end
  end

  describe "GET words" do
    context "when no word is queried" do
      before { get '/words' }

      it "returns an error" do
        expect(json).to eq({ "validation_error" => "Parameter word is required" })
      end

      it "returns status code 422" do
        expect(response.status).to eq(422)
      end
    end

    context "when queried word was not processed" do
      let(:word) { "not_present" }
      before { get '/words', params: { word: word } }

      it "returns 0" do
        expect(json).to eq({ not_present: 0 })
      end
    end

    context "when queried word is found" do
      let(:word) { "found_5_times" }
      before { get '/words', params: { word: word } }

      it "returns it's statistics" do
        expect(json).to eq({ found_5_times: 5 })
      end
    end

    ["with space", "with?", "with@"].each do |illigal_word|

      context "when queried word includes illegal characters such as '#{illigal_word}'" do
        before { get '/words', { params: { word: "with space" } } }

        it "returns an error" do
          expect(json).to eq({ "validation_error" => "Parameter word must match format (?-mix:^[\\w|-]*$)" })
        end

        it "returns status code 422" do
          expect(response.status).to eq(422)
        end
      end
    end
  end
end
