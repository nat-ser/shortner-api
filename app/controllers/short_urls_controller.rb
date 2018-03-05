# frozen_string_literal: true

class ShortUrlsController < ApplicationController
  def create
    url = Url.create!(url_params)
    short_url = ShortUrl.for_url(url).first
    if short_url.present?
      url.short_url = short_url
      json_response(short_url)
    else
      short_address = url.shortened
      short_url = ShortUrl.create(short_address: short_address)
      json_response(short_url, :created)
    end
  end

  def index; end

  def show; end

  private

  def url_params
    params.permit(:short_url_id, :full_address, :device_type)
  end
end
