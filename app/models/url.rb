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
  belongs_to :short_url
end
