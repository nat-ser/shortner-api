# frozen_string_literal: true

# == Schema Information
#
# Table name: urls
#
#  id             :integer          not null, primary key
#  short_url_id   :integer
#  full_address   :string           not null
#  device_type    :string           not null
#  redirect_count :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

# target url
class Url < ApplicationRecord
  belongs_to :short_url, optional: true

  validates :full_address, :device_type, presence: true

  def shortened_address
    id.to_s(36)
  end

  def increment_redirect_count
    increment!(:redirect_count)
  end
end
