# frozen_string_literal: true

require "rails_helper"
require "support/request_spec_helper"

describe "Short Url API", type: :request do
  include RequestSpecHelper
  let(:valid_url) { Faker::Internet.url }
  let(:device_type) { "mobile" }

  describe "POST /short_urls" do
    let(:valid_attributes) do
      { full_address: valid_url, device_type: device_type }
    end

    context "when the request is valid" do
      before { post "/short_urls", params: valid_attributes }

      it "creates a short url" do
        expect(json["short_address"]).to eq(Url.last.shortened)
      end

      it "returns status code 201" do
        expect(response).to have_http_status(201)
      end
    end

    context "when the request is invalid" do
      before { post "/short_urls", params: { device_type: "mobile" } }

      it "returns status code 422" do
        expect(response).to have_http_status(422)
      end

      it "returns a validation failure message" do
        expect(response.body)
          .to match(/Validation failed: Full address can't be blank/)
      end
    end
  end
end
