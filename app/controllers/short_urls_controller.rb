# frozen_string_literal: true

class ShortUrlsController < ApplicationController
  before_action :detect_device_format, only: [:show]

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

  def show
    short_url = ShortUrl.find_by!(short_address: params[:friendly_id])
    url = short_url.urls.find {|x| x.device_type == request.variant.first.to_s }
    url.redirect_count += 1
    redirect_to url.full_address, status: :moved_permanently
  end

  private

  def url_params
    params.permit(:short_url_id, :full_address, :device_type)
  end

  def detect_device_format
    case request.user_agent
    when /iPad/i
      request.variant = :tablet
    when /iPhone/i
      request.variant = :mobile
    when /Android/i && /mobile/i
      request.variant = :mobile
    when /Android/i
      request.variant = :tablet
    when /Windows Phone/i
      request.variant = :mobile
    else
      request.variant = :desktop
    end
  end
end
