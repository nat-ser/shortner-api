# frozen_string_literal: true

class ShortUrl < ApplicationRecord
  has_many :urls
end
