# frozen_string_literal: true

# == Schema Information
#
# Table name: short_urls
#
#  id            :integer          not null, primary key
#  short_address :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

# shortened url that redirects to target url based on device type
class ShortUrl < ApplicationRecord
  has_many :urls, dependent: :destroy

  validates :short_address, presence: true

  # this application level validation is here for clarity but has no functional purpose
  # not necessary due to shortening algorithm based on url id
  validates :short_address, uniqueness: true

  accepts_nested_attributes_for :urls

  def self.for_url(url)
    joins(:urls).where(urls: { full_address: url.full_address })
  end
end
