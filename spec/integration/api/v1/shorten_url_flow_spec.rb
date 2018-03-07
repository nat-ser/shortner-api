# frozen_string_literal: true

require "rails_helper"
require "support/request_spec_helper"

describe "Shortening flow", type: :request do
  include RequestSpecHelper

  describe "flow" do
    let(:first_created_twin_peak_url_attrs) do
      {
        full_address: "https://twin_peaks.com",
        device_type: "mobile"
      }
    end
    let(:twin_peak_url_attrs) do
      {
        full_address: "https://twin_peaks.com",
        device_type: "tablet"
      }
    end
    let(:first_created_steak_url_attrs) do
      {
        full_address: "https://steak.com",
        device_type: "desktop"
      }
    end
    let(:steak_url_attrs) do
      {
        full_address: "https://steak.com",
        device_type: "tablet"
      }
    end

    it "conducts flow" do
      post api_v1_short_urls_path, params: first_created_twin_peak_url_attrs
      post api_v1_short_urls_path, params: twin_peak_url_attrs
      post api_v1_short_urls_path, params: first_created_steak_url_attrs
      post api_v1_short_urls_path, params: steak_url_attrs

      # binding.pry
      get api_v1_friendly_path("1"),
        headers: { "HTTP_USER_AGENT": "mobile" }
      # get api_v1_friendly_path("1")

      get api_v1_short_urls_path
      pp json
    end
  end
  # creates 4 new urls and 2 short urls
  # they all redirect to right url
  # the index returns correctly serialized list
end
