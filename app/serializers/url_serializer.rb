class UrlSerializer < ActiveModel::Serializer
  attributes :id, :full_address, :device_type, :redirect_count, :created_at, :updated_at

  belongs_to :short_url
end
