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

  # this validation is here for clarity only but has no functional purpose
  # not necessary due to shortening algorithm based on url id
  validates :short_address, uniqueness: true

  def self.for_full_address(url)
    joins(:urls).where(urls: { full_address: url.full_address }).first
  end
end
