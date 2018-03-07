# frozen_string_literal: true

require "rails_helper"
require "support/request_spec_helper"

describe "Short Url API", type: :request do
  include RequestSpecHelper

  describe "POST api/v1/short_urls" do
    let(:full_address) { "https://jooraccess.com/" }
    let(:valid_attributes) do
      { full_address: full_address, device_type: "mobile" }
    end

    context "when the request is valid and there is no existing short url" do
      before { post api_v1_short_urls_path, params: valid_attributes }

      it "creates a short url" do
        # `json` is a custom helper to parse JSON responses
        expect(json["short_address"]).to eq(Url.last.shortened_address)
      end

      it "creates an association between created url and shortened_address url" do
        url = Url.find_by(full_address: full_address, device_type: "mobile")
        short_url = ShortUrl.last
        expect(url.short_url).to eq(short_url)
        expect(short_url.urls.include?(url)).to eq(true)
      end

      it "returns status code 201" do
        expect(response).to have_http_status(201)
      end
    end

    context "when the request is valid and there is an existing short url" do
      let!(:short_url_with_targets) { create(:short_url_with_targets) }

      before do
        post api_v1_short_urls_path, params: valid_attributes
      end

      it "creates a short url" do
        expect(json["short_address"]).to eq("1")
      end

      it "creates an association between created url and shortened_address url" do
        url = Url.find_by(full_address: full_address, device_type: "mobile")

        expect(url.short_url).to eq(short_url_with_targets)
        expect(short_url_with_targets.urls.include?(url)).to eq(true)
      end

      it "returns status code 201" do
        expect(response).to have_http_status(200)
      end
    end

    context "when the request is invalid" do
      before { post api_v1_short_urls_path, params: { device_type: "mobile" } }

      it "returns status code 422" do
        expect(response).to have_http_status(422)
      end

      it "returns a validation failure message" do
        expect(response.body)
          .to match(/Validation failed: Full address can't be blank/)
      end
    end
  end

  describe "GET api/v1/:friendly_id" do
    let(:short_url_with_one_target) { create(:short_url_with_targets) }
    let(:mobile_url) { create(:url, device_type: "mobile") }

    before do
      short_url_with_one_target.urls << mobile_url
      get api_v1_friendly_path(friendly_id),
          headers: { "HTTP_USER_AGENT": "mobile" }
    end

    context "when the record exists" do
      let(:friendly_id) { "1" }

      it "redirects to the target url" do
        expect(response).to redirect_to("https://jooraccess.com/")
      end

      it "increments the redirect count for the target url" do
        target_urls = short_url_with_one_target.urls
        target_url = target_urls.find { |x| x.device_type == "mobile" }
        expect(target_url.redirect_count).to eq(1)
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

  describe "GET api/v1/short_urls" do
    context "when the records exist" do
      before do
        (1..2).to_a.each do |id|
          ShortUrl.create(short_address: id.to_s)
        end
        get(api_v1_short_urls_path)
      end

      it "returns shorened urls" do
        expect(json).not_to be_empty
        expect(json.size).to eq(2)
      end

      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end
    end

    context "when no records exist" do
      it "returns status code 204" do
        get(api_v1_short_urls_path)
        expect(response).to have_http_status(204)
      end
    end
  end
end
