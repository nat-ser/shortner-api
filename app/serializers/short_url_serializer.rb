# frozen_string_literal: true

class ShortUrlSerializer < ActiveModel::Serializer
  attributes :id,
             :short_address,
             :created_at,
             :updated_at,
             :hours_since_creation

  has_many :urls

  def hours_since_creation
    (Time.now - object.created_at.to_time) / 1.hour
  end
end
