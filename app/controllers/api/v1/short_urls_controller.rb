# frozen_string_literal: true
module Api::V1
  class ShortUrlsController < ApplicationController
    before_action :detect_device_format, only: [:show]

    def create
      url = Url.create!(url_params)
      short_url = ShortUrl.for_url(url).first
      # TODO refactor logic by making a custom short_url getter
      if short_url.present?
        short_url.urls << url
        json_response(short_url)
      else
        short_address = url.shortened
        short_url = ShortUrl.create(short_address: short_address)
        short_url.urls << url
        json_response(short_url, :created)
      end
    end

    def index
      short_urls = ShortUrl.all
      if short_urls.empty?
        json_response(short_urls, :no_content)
      else
        json_response(short_urls)
      end
    end

    def show
      short_url = ShortUrl.find_by!(short_address: params[:friendly_id])
      device_type = request.variant.first.to_s
      url = short_url.urls.find { |x| x.device_type == device_type }
      url.increment_redirect_count
      redirect_to url.full_address, status: :moved_permanently
    end

    private

    def url_params
      params.permit(:short_url, :full_address, :device_type)
    end

    def detect_device_format
      request.variant = case request.user_agent
                        when /iPad/i
                          :tablet
                        when /iPhone/i
                          :mobile
                        when /Android/i && /mobile/i
                          :mobile
                        when /Android/i
                          :tablet
                        when /Windows Phone/i
                          :mobile
                        else
                          :desktop
                        end
    end
  end
end
