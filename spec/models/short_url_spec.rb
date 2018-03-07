# frozen_string_literal: true

require "rails_helper"

describe ShortUrl, type: :model do
  describe ".for_full_address"
    let(:desktop_url) { create(:url) }
    let(:mobile_url) { create(:url, id: 2, device_type: "mobile") }
    let(:short_url) { create(:short_url, short_address: "1") }
  it "returns any other short urls for the same full url address" do
    short_url.urls << desktop_url

    expect(ShortUrl.for_full_address(mobile_url)).to eq(short_url)
  end
end
