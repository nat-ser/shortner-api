# frozen_string_literal: true

require "rails_helper"
require "support/request_spec_helper"

describe "Short Url API", type: :request do
  include RequestSpecHelper
  let(:valid_url) { "https://jooraccess.com/" }
  let(:device_type) { "mobile" }

  describe "POST /short_urls" do
    let(:valid_attributes) do
      { full_address: valid_url, device_type: device_type }
    end

    context "when the request is valid and there is no existing short url" do
      before { post "/short_urls", params: valid_attributes }

      it "creates a short url" do
        expect(json["short_address"]).to eq(Url.last.shortened)
      end

      it "returns status code 201" do
        expect(response).to have_http_status(201)
      end
    end

    context "when the request is valid and there is an existing short url" do
      before do
        create(:short_url_with_targets)
        post "/short_urls", params: valid_attributes
      end

      it "creates a short url" do
        expect(json["short_address"]).to eq("1")
      end

      it "returns status code 201" do
        expect(response).to have_http_status(200)
      end
    end

    context "when the request is valid"

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
