require 'rails_helper'

RSpec.describe 'Counting API', type: :request do
  let(:endpoint) { '/count' }

  before do
    @redis = Redis.new
    @redis.flushall
  end

  describe "POST count" do
    context "when posted data is valid" do
      let(:valid_data) { { text: "sometext" } }

      before { post endpoint, params: valid_data }

      it "returns status code 200" do
        expect(response.status).to eq(200)
      end
    end

    context "when posted data is not valid" do
      before { post endpoint, params: { not: "valid" } }

      it "returns status code 422" do
        expect(response.status).to eq(422)
      end

      it "returns an error" do
        expect(json).to eq({ "validation_error" => "Parameter text is required" })
      end
    end

    context "when no data is posted" do
      before { post endpoint }

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
      before { get endpoint }

      it "returns an error" do
        expect(json).to eq({ "validation_error" => "Parameter word is required" })
      end

      it "returns status code 422" do
        expect(response.status).to eq(422)
      end
    end

    ["with space", "with?", "with@"].each do |illigal_word|
      context "when queried word includes illegal characters such as '#{illigal_word}'" do
        before { get endpoint, { params: { word: "with space" } } }

        it "returns an error" do
          expect(json).to eq({ "validation_error" => "Parameter word must match format (?-mix:^[\\w|-]*$)" })
        end

        it "returns status code 422" do
          expect(response.status).to eq(422)
        end
      end
    end

    context "when queried word does not appear" do
      before { get endpoint, { params: { word: "does_not_exist" } } }

      it "returns 0" do
        expect(response.body).to eq("0")
      end

      it "returns status code 200" do
        expect(response.status).to eq(200)
      end
    end

    context "when queried word appears" do
      before do
        @redis.set("wordcount:5_times", 5)
        get endpoint, { params: { word: "5_times" } }
      end

      it "returns the word count" do
        expect(response.body).to eq("5")
      end

      it "returns status code 200" do
        expect(response.status).to eq(200)
      end
    end
  end
end
