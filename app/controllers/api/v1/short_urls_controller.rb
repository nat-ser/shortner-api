# frozen_string_literal: true

module Api
  module V1
    class ShortUrlsController < ApplicationController
      def create
        url = Url.create!(url_params)
        short_url = ShortUrl.existing_url_for_full_address(url)
        if short_url.present?
          status = :ok
        else
          short_address = url.shortened_address
          short_url = ShortUrl.create(short_address: short_address)
          status = :created
        end
        short_url.urls << url
        json_response(short_url, status)
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
        url = short_url.urls.find { |x| x.device_type == device_type }
        url.increment_redirect_count
        redirect_to url.full_address, status: :moved_permanently
      end

      private

      def url_params
        params.permit(:short_url, :full_address, :device_type)
      end

      def device_type
        case request.user_agent
        when /Android/i && /mobile/i
          "mobile"
        when /iPhone/i
          "mobile"
        when /Windows Phone/i
          "mobile"
        when /iPad/i
          "tablet"
        when /Android/i
          "tablet"
        else
          "desktop"
          end
      end
    end
  end
end
