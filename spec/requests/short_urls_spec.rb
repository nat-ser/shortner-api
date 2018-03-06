# frozen_string_literal: true

require "rails_helper"
require "support/request_spec_helper"

describe "Short Url API", type: :request do
  include RequestSpecHelper

  describe "POST /short_urls" do
    let(:valid_attributes) do
      { full_address: "https://jooraccess.com/", device_type: "mobile" }
    end

    context "when the request is valid and there is no existing short url" do
      before { post "/short_urls", params: valid_attributes }

      it "creates a short url" do
        # `json` is a custom helper to parse JSON responses
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

  describe "GET /:friendly_id" do
    let(:short_url_with_one_target) { create(:short_url_with_targets) }
    let(:mobile_url) { create(:url, id: 2, device_type: "mobile") }

    before do
      short_url_with_one_target.urls << mobile_url
      get "/#{friendly_id}"
    end

    context "when the record exists" do
      let(:friendly_id) { "1" }

      it "returns the url" do
        request.env["HTTP_USER_AGENT"] = "iPhone"
        expect(response).to redirect_to("https://jooraccess.com/")
      end

      it "returns status code 301" do
        expect(response).to have_http_status(301)
      end
    end

    context "when the record does not exist" do
      let(:friendly_id) { "404short" }

      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end

      it "returns a not found message" do
        expect(response.body).to match(/Couldn't find ShortUrl/)
      end
    end
  end

  describe "GET /short_urls" do
    context "when the records exist" do
      before do
        (1..4).to_a.each do |id|
          desktop_url = create(
            :url, id: id,
            full_address: Faker::Internet.url,
            device_type: "desktop"
          )
          mobile_url = create(
            :url,
            id: (id + 10),
            full_address: Faker::Internet.url,
            device_type: "mobile"
          )
          shortened_url = create(:short_url, short_address: desktop_url.shortened)
          shortened_url.urls << mobile_url
          shortened_url.urls << desktop_url
        end
       get "/short_urls"
      end

      it "returns shorened urls" do
        expect(json).not_to be_empty
        expect(json.size).to eq(4)
      end

      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end
    end

    context "when no records exist" do
      it "returns status code 204" do
        get "/short_urls"
        expect(response).to have_http_status(204)
      end
    end
  end
end
