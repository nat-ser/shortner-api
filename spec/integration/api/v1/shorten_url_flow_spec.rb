# frozen_string_literal: true

require "rails_helper"
require "support/request_spec_helper"

describe "POST /short_urls, GET /friendly_id, and POST /short_urls requests", type: :request do
  include RequestSpecHelper

  let(:first_created_twin_peak_url_attrs) do
    {
      full_address: "https://twin_peaks.com",
      device_type: "mobile"
    }
  end
  let(:first_created_steak_url_attrs) do
    {
      full_address: "https://steak.com",
      device_type: "desktop"
    }
  end
  let(:twin_peak_url_attrs) do
    {
      full_address: "https://twin_peaks.com",
      device_type: "tablet"
    }
  end
  let(:steak_url_attrs) do
    {
      full_address: "https://steak.com",
      device_type: "tablet"
    }
  end

  it "produce expected index response after flow completion" do
    Timecop.freeze(Time.local(1990))
    post api_v1_short_urls_path, params: first_created_twin_peak_url_attrs
    post api_v1_short_urls_path, params: first_created_steak_url_attrs

    Timecop.freeze(Time.local(2008))
    post api_v1_short_urls_path, params: twin_peak_url_attrs
    post api_v1_short_urls_path, params: steak_url_attrs
    get api_v1_friendly_path("1"),
        headers: { "HTTP_USER_AGENT": "mobile" }
    get api_v1_friendly_path("1"),
        headers: { "HTTP_USER_AGENT": "Android" }

    get api_v1_short_urls_path

    formatted_json = JSON.pretty_generate(json)
    expect(file_fixture("short_urls_index.json").read).to eq(formatted_json)
  end
end
