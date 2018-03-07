# frozen_string_literal: true

class ShortUrlSerializer < ActiveModel::Serializer
  attributes :id,
             :short_address,
             :hours_since_creation,
             :created_at,
             :updated_at

  has_many :urls

  def hours_since_creation
    (Time.now - object.created_at.to_time) / 1.hour
  end
end
