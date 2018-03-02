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
  has_many :urls
end
