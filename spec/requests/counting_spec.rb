require 'rails_helper'

RSpec.describe 'Counting API', type: :request do
  let(:endpoint) { '/count' }

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
  end
end
