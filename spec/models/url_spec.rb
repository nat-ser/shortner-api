# frozen_string_literal: true

require "rails_helper"

describe Url, type: :model do
  describe ".shortened_address" do
    let(:url) { create(:url, id: 223_647_634) }

    it "returns any other short urls for the same full url address" do
      expect(url.shortened_address).to eq("3p5jma")
    end
  end

  describe ".increment_redirect_count" do
    let(:url) { create(:url, redirect_count: 2) }

    it "increments redirect count of target url" do
      url.increment_redirect_count
      expect(url.redirect_count).to eq(3)
    end
  end
end
